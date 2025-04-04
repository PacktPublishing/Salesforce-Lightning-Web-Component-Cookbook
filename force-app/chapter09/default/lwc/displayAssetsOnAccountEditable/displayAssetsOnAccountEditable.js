import { LightningElement, api, wire } from 'lwc';
import {  getPicklistValues } from 'lightning/uiObjectInfoApi';
import { notifyRecordUpdateAvailable } from 'lightning/uiRecordApi';
import STATUS_FIELD from "@salesforce/schema/Asset.Status";
import returnAssetsByAccount from '@salesforce/apex/DisplayAssetsController.returnAssetsByAccount';
import returnAssetCount from '@salesforce/apex/DisplayAssetsController.returnAssetCount';
import updateAssetWrappers from '@salesforce/apex/DisplayAssetsController.updateAssetWrappers';
import NO_IMAGE_FOUND from '@salesforce/resourceUrl/NoImageFound';
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
    error;

    statusPickvals = [];
    draftValues = [];

    assetColumns = [
        {
            type: 'text',
            fieldName: 'Name',
            label: 'Name'
        },
        {
            type: 'text',
            fieldName: 'Department__c',
            label: 'Department'
        },
        {
            type: 'text',
            fieldName: 'Object_ID__c',
            label: 'Asset Id'
        },
        {
            type: 'picklistColumn',
            fieldName: 'Status',
            label: 'Display Status',
            editable: true,
            typeAttributes : {
                label: {fieldName: 'statusLabel'},
                value: {fieldName: 'statusValue'},
                placeholder: {fieldName: 'statusPlaceholder'},
                options: {fieldName: 'statusOptions'}
            }
        }
    ];


    @wire(getPicklistValues, { recordTypeId: '012000000000000AAA', fieldApiName: STATUS_FIELD })
    pickvals(result) {
        if(result.data) {
            let pickvals = result.data['values'];

            pickvals.forEach(val => this.statusPickvals.push({label: val['label'], value: val['value']}));

            console.log(JSON.stringify(this.statusPickvals));
        } else if (result.error) {
            this.error = result.error;
            utility.showNotif('There has been an error loading pickvals!', this.error.message, 'error');
        }
    }

    async connectedCallback() {
        utility = new Utilities(this);
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
        return await returnAssetsByAccount({ accountIdString : this.recordId, lim : this.limit, offset : this.offset });
    }

    async refreshAssets() {
        let idsToUpdate = [];

        this.draftValues.forEach(draft => idsToUpdate.push({recordId : draft.Id}));

        await notifyRecordUpdateAvailable(idsToUpdate);

        this.draftValues = [];
    }

    formatAssets(tempAssets) {
        tempAssets.forEach(asset => {
            if(!asset.hasOwnProperty('Primary_Image_Small__c')) {
                asset['Primary_Image_Small__c'] = NO_IMAGE_FOUND;

                if(!asset.Is_Public_Domain__c) {
                    asset['Description'] = 'This image is not in the public domain, so it cannot be displayed here.';
                }
            }

            asset['statusLabel'] = asset.Status;
            asset['statusValue'] = asset.Status;
            asset['statusPlaceholder'] = asset.Status;
            asset['statusOptions'] = this.statusPickvals.filter(val => val.value != asset.statusValue);
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
        this[NavigationMixin.Navigate]({ 
           type: 'standard__recordPage', 
           attributes: { 
              recordId: this.selectedAsset.Id ,
              actionName: 'view'
           },
        });
    }

    handleInlineEdit(event) {
        let draftValue = event.detail.draftValues[0];

        let draftValueIndex = this.assetsForDatatable.findIndex(draft => draft.Id == draftValue.Id);

        let tempAsset = this.assetsForDatatable[draftValueIndex];

        tempAsset['oldLabel'] = tempAsset.statusLabel;
        tempAsset['oldValue'] = tempAsset.statusValue;
        tempAsset['oldPlaceholder'] = tempAsset.statusPlaceholder;
        tempAsset['oldOptions'] = tempAsset.statusOptions;

        tempAsset['statusLabel'] = draftValue.Status;
        tempAsset['statusValue'] = draftValue.Status;
        tempAsset['statusPlaceholder'] = draftValue.Status;
        tempAsset['statusOptions'] = this.statusPickvals.filter(val => val.value != tempAsset.statusValue);

        this.assetsForDatatable[draftValueIndex] = tempAsset;

        let draftIndex = this.draftValues.findIndex(draft => draft.Id == draftValue.Id);

        if(draftIndex < 0) {
            this.draftValues.push(draftValue);
        } else {
            this.draftValues[draftIndex] = draftValue;
        }
    }

    async handleInlineEditSave() {
        let jsonToParse = JSON.stringify(this.draftValues);

        try {
            await updateAssetWrappers({ jsonToParse : jsonToParse});
            this.refreshAssets();
        } catch(error) {
            this.error = error;
            utility.showNotif('There has been an error saving assets!', this.error.message, 'error');
        }
    }

    handleInlineEditCancel() {
        this.draftValues.forEach(draft => {
            let draftValueIndex = this.assetsForDatatable.findIndex(draftValue => draft.Id == draftValue.Id);

            let tempAsset = this.assetsForDatatable[draftValueIndex];
            tempAsset['statusLabel'] = tempAsset['oldLabel'];
            tempAsset['statusValue'] = tempAsset['oldValue'];
            tempAsset['statusPlaceholder'] = tempAsset['oldPlaceholder'];
            tempAsset['statusOptions'] = tempAsset['oldOptions'];

            this.assetsForDatatable[draftValueIndex] = tempAsset;
        });

        this.draftValues = [];
    }
}