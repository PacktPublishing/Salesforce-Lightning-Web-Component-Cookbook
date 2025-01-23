import { LightningElement, api, wire } from 'lwc';
import returnAssetsByAccount from '@salesforce/apex/DisplayAssetsController.returnAssetsByAccount';
import returnAssetCount from '@salesforce/apex/DisplayAssetsController.returnAssetCount';
import NO_IMAGE_FOUND from '@salesforce/resourceUrl/NoImageFound';
import FORM_FACTOR from '@salesforce/client/formFactor';
import { WIDE_COLUMNS_DEFINITION, NARROW_COLUMNS_DEFINITION } from './assetsColumns';
import Utilities from 'c/notifUtils';
let utility;

export default class DisplayAssetsOnAccount extends LightningElement {
    @api recordId
    scrollingAssets = [];
    assetsForDatatable = [];
    preselectedRows = [];
    _wiredAssets;
    offset = 0;
    limit = 5;
    screenWidth;
    componentWidth;
    error

    get assetColumns() {
        if(FORM_FACTOR == 'Large' && this.screenWidth == 'Large') {
            return WIDE_COLUMNS_DEFINITION;
        } else {
            return NARROW_COLUMNS_DEFINITION;
        }
    }

    async connectedCallback() {
        utility = new Utilities(this);

        window.addEventListener('resize', this.resizeFunction);

        try {
            const returnedAssets = await returnAssetsByAccount({ accountIdString : this.recordId, lim : this.limit, offset : this.offset });
            let tempAssets = JSON.parse(JSON.stringify(returnedAssets));

            this.assetsForDatatable = this.formatAssets(tempAssets);

            let firstRecord = this.assetsForDatatable[0];
            
            this.preselectedRows = [firstRecord.Id];
            this.scrollingAssets = new Set([firstRecord, ...this.scrollingAssets]);

            this.error = undefined;

            this.resizeFunction();
        } catch (error) {
            this.error = error;
            utility.showNotif('There has been an error loading assets!', this.error.message, 'error');
        }
    }

    @wire(returnAssetCount, { accountIdString : '$recordId'})
    totalAssets;

    formatAssets(tempAssets) {
        tempAssets.forEach(asset => {
            if(!asset.hasOwnProperty('Primary_Image_Small__c')) {
                asset['Primary_Image_Small__c'] = NO_IMAGE_FOUND;

                if(!asset.Is_Public_Domain__c) {
                    asset['Description'] = 'This image is not in the public domain, so it cannot be displayed here.';
                }
            }
        });

        return tempAssets;
    }

    updateCarousel(event) {
        let selectedRows = event.detail.selectedRows;
        this.preselectedRows = [selectedRows[0].Id];

        this.scrollingAssets = new Set([...selectedRows, ...this.scrollingAssets]);
    }

    async loadMoreAssets() {
        if(this.offset < this.totalAssets.data) {
            try {
                this.offset += this.limit;
        
                const returnedAssets = await returnAssetsByAccount({ accountIdString : this.recordId, lim : this.limit, offset : this.offset });
                let tempAssets = JSON.parse(JSON.stringify(returnedAssets));

                this.assetsForDatatable = [...this.assetsForDatatable, ...this.formatAssets(tempAssets)];
    
                this.error = undefined;
            } catch (error) {
                this.error = error;
                utility.showNotif('There has been an error loading more assets!', this.error.message, 'error');
            }    
        }
    }

    resizeFunction = () => {
		let component = this.template.querySelector('.displayAssetComp');
		this.componentWidth = component.getBoundingClientRect().width;
		if(this.componentWidth < 600) {
			this.screenWidth = 'Small';
		}
		else {
			this.screenWidth = 'Large';
		}
	}

}