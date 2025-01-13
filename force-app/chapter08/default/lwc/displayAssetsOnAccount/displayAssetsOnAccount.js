import { LightningElement, api, wire } from 'lwc';
import returnAssetsByAccount from '@salesforce/apex/DisplayAssetsController.returnAssetsByAccount';
import returnAssetCount from '@salesforce/apex/DisplayAssetsController.returnAssetCount';
import NO_IMAGE_FOUND from '@salesforce/resourceUrl/NoImageFound';
import { WIDE_COLUMNS_DEFINITION } from './assetsColumns';
import Utilities from 'c/notifUtils';
let utility;

export default class DisplayAssetsOnAccount extends LightningElement {
    @api recordId
    isLoading = true;
    scrollingAssets = [];
    allAssets = [];
    assetsForDatatable;
    preselectedRows = [];
    _wiredAssets;
    offset = 0;
    limit = 5;
    error

    get assetColumns() {
        return WIDE_COLUMNS_DEFINITION;
    }

    connectedCallback() {
        utility = new Utilities(this);
    }

    @wire(returnAssetCount, { accountIdString : '$recordId'})
    totalAssets;

    @wire(returnAssetsByAccount, { accountIdString : '$recordId', lim : '$limit', offset : '$offset'})
    wiredAccounts(result) {
        this._wiredAssets = result;
        if (result.data) {
            let tempAssets = JSON.parse(JSON.stringify(result.data));

            this.allAssets = this.formatAssets(tempAssets);
            this.assetsForDatatable = this.allAssets;

            this.preselectRows();

            this.error = undefined;
            this.loading = false;
        } else if(result.error) {
            this.error = result.error;
            this.scrollingAssets = undefined;
            this.assetsForDatatable = undefined;
            utility.showNotif('There has been an error loading assets!', this.error, 'error');
            this.loading = false;
        }
    }

    formatAssets(tempAssets) {
        tempAssets.forEach(asset => {
            if(!asset.hasOwnProperty('Primary_Image_Small__c')) {
                asset['Primary_Image_Small__c'] = NO_IMAGE_FOUND;
            }
            if(!asset.Is_Public_Domain__c) {
                asset['Description'] = 'This image is not in the public domain, so it cannot be displayed here.';
            }
            this.allAssets.push(asset);
        });

        return tempAssets;
    }

    preselectRows() {
        this.preselectedRows = [this.assetsForDatatable[0].Id];
    }

    updateCarousel(event) {
        this.isLoading = true;

        let selectedRows = event.detail.selectedRows;
        this.preselectedRows = [selectedRows[0].Id];

        console.log('selectedRows: ' + JSON.stringify(selectedRows));
        this.scrollingAssets = new Set([...selectedRows, ...this.scrollingAssets]);

        this.isLoading = false;
    }

    async loadMoreAssets() {
        console.log('totalAssets: ' + JSON.stringify(this.totalAssets));
        if(this.offset < this.totalAssets.data) {
            try {
                this.isLoading = true;
                this.offset += this.limit;
        
                const nextAssets = await returnAssetsByAccount({ accountIdString : this.recordId, lim : this.limit, offset : this.offset });

                console.log('nextAssets: ' + nextAssets);

                // let tempAssets = JSON.parse(JSON.stringify(nextAssets));

                // let assetsToAdd = this.formatAssets(tempAssets);
        
                // this.allAssets = [...this.allAssets, ...assetsToAdd];
                // this.assetsForDatatable = this.allAssets;
        
                // this.isLoading = false;    
            } catch(error) {
                this.error = error;
                utility.showNotif('There has been an error loading more assets!', this.error.message, 'error');
            }    
        }
    }

}