import { LightningElement, api, wire } from 'lwc';
import returnAssetsByAccount from '@salesforce/apex/DisplayAssetsController.returnAssetsByAccount';
import returnAssetCount from '@salesforce/apex/DisplayAssetsController.returnAssetCount';
import NO_IMAGE_FOUND from '@salesforce/resourceUrl/NoImageFound';
import FORM_FACTOR from '@salesforce/client/formFactor';
import { WIDE_COLUMNS_DEFINITION, NARROW_COLUMNS_DEFINITION } from './assetsColumns';
import { NavigationMixin } from 'lightning/navigation';
import Utilities from 'c/notifUtils';
let utility;

export default class DisplayAssetsOnAccount extends NavigationMixin(LightningElement) {
    @api recordId
    scrollingAssets = [];
    assetsForDatatable;
    selectedAsset;
    selectedRows = [];
    offset = 0;
    limit = 5;
    componentWidth;
    componentWidthPixels;
    error;

    get assetColumns() {
        if(FORM_FACTOR === 'Large' && this.componentWidth === 'Wide') {
            return WIDE_COLUMNS_DEFINITION;
        } 
        return NARROW_COLUMNS_DEFINITION;
    }

    async connectedCallback() {
        utility = new Utilities(this);

        window.addEventListener('resize', this.resizeFunction);

        try {
            const returnedAssets = await this.getAssets();
            let tempAssets = JSON.parse(JSON.stringify(returnedAssets));

            this.assetsForDatatable = this.formatAssets(tempAssets);

            this.selectedAsset = this.assetsForDatatable[0];
            this.selectedRows = [this.selectedAsset.Id]

            this.error = undefined;
        } catch (error) {
            this.error = error;
            utility.showNotif('There has been an error loading assets!', this.error.message, 'error');
        }
    }

    @wire(returnAssetCount, { accountIdString : '$recordId'})
    totalAssets;

    async getAssets() {
        return returnAssetsByAccount({ accountIdString : this.recordId, lim : this.limit, offset : this.offset });
    }

    formatAssets(tempAssets) {
        tempAssets.forEach(asset => {
            if(!Object.prototype.hasOwnProperty.call(asset, 'Primary_Image_Small__c')) {
                asset.Primary_Image_Small__c = NO_IMAGE_FOUND;

                if(!asset.Is_Public_Domain__c) {
                    asset.Description = 'This image is not in the public domain, so it cannot be displayed here.';
                }
            }
        });

        return tempAssets;
    }

    async loadMoreAssets() {
        if(this.offset < this.totalAssets.data) {
            try {
                this.offset += this.limit;
        
                const returnedAssets = await this.getAssets();
                let tempAssets = JSON.parse(JSON.stringify(returnedAssets));

                this.assetsForDatatable = [...this.assetsForDatatable, ...this.formatAssets(tempAssets)];
    
                this.error = undefined;
            } catch (error) {
                this.error = error;
                utility.showNotif('There has been an error loading more assets!', this.error.message, 'error');
            }    
        }
    }

    updateCarousel(event) {
        let selectedAssetRows = event.detail.selectedRows;
        this.selectedAsset = selectedAssetRows[0];
        this.selectedRows = [this.selectedAsset.Id];
    }

    handleOpenAssetPage() {
        // window.open(this.selectedAsset.Asset_URL__c, '_blank').focus();

        this[NavigationMixin.Navigate]({ 
           type: 'standard__recordPage', 
           attributes: { 
              recordId: this.selectedAsset.Id,
              actionName: 'view'
           },
        });
    }

    resizeFunction = () => {
		let component = this.template.querySelector('.displayAssetComp');
		this.componentWidthPixels = component.getBoundingClientRect().width;
		if(this.componentWidthPixels < 600) {
			this.componentWidth = 'Narrow';
		}
		else {
			this.componentWidth = 'Wide';
		}
	}
}