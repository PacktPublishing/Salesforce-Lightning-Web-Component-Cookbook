import { LightningElement, api } from 'lwc';
import searchAssetWrappers from '@salesforce/apex/AddAssetController.searchAssetWrappers';
import saveAssetWrappers from '@salesforce/apex/AddAssetController.saveAssetWrappers';
import Utilities from 'c/notifUtils';
let utility;

export default class AddAssetPicker extends LightningElement {
    @api recordId;
    @api searchTerm;
    @api departmentId;
    @api selectedAssets;
    searchResults = [];
    options;
    isLoaded = false;
    isNull = false;
    savePressed = false;
    buttonsDisabled = true;

    connectedCallback() {
        utility = new Utilities(this);
        this.sendSearchFetchAPI();
    }

    get assetsLoaded() {
        return this.isLoaded && this.isNull != true;
    }

    get listDisabled() {
        return this.savePressed;
    }

    async sendSearchApex() {
        try {
            const searchResultsJSON = await searchAssetWrappers( {search : this.searchTerm, departmentId : this.departmentId} );

            if(searchResultsJSON == null) {
                this.isNull = true;
            } else {
                let searchResults = JSON.parse(searchResultsJSON);
                
                for(let sr of searchResults) {
                    let srClone = {label:sr.title, value:sr.objectId};
                    this.searchResults.push(srClone);
                }

                this.searchResults.sort((a, b) => (a.label - b.label) ? 1 : -1);

                this.options = this.searchResults;
            }
        } catch(error) {
            this.options = undefined;
            utility.showNotif('There has been an error!', error, 'error');
        }
        this.isLoaded = true;
    }

    async sendSearchFetchAPI() {
        try {
            const sendSearchFetch = await fetch('https://collectionapi.metmuseum.org/public/collection/v1/search?q=' + JSON.stringify(this.searchTerm).slice(1, -1) + '&departmentId=' + this.departmentId);

            let sendSearchResponse = await sendSearchFetch.json();

            if(sendSearchResponse.objectIDs == null) {
                this.isNull = true;
            } else {
                this.searchResults = await this.searchObjects(sendSearchResponse.objectIDs);

                this.searchResults.sort((a, b) => (a.label - b.label) ? 1 : -1);

                this.options = this.searchResults;

                this.isLoaded = true;
            }
        } catch(error) {
            this.options = undefined;
            utility.showNotif('There has been an error!', 'There has been an error in the Send Search function.', 'error');
        }
    }

    async searchObjects(objectIds) {
        try{
            let objectsToReturn = [];

            for(let objectId of objectIds) {
                let getObjectResponse = await this.getObject(objectId);

                objectsToReturn.push(getObjectResponse);
            }

            return objectsToReturn;
        } catch(error) {
            utility.showNotif('There has been an error!', 'There has been an error in the Search Objects function.', 'error');
        }
    }

    async getObject(objectId) {
        try{
            const getObjectFetch = await fetch('https://collectionapi.metmuseum.org/public/collection/v1/objects/' + objectId);

            let objectResponse = await getObjectFetch.json();
            
            let objectResponseClone = {label:objectResponse.title, value:objectResponse.objectID.toString()};

            return objectResponseClone;

        } catch(error) {
            utility.showNotif('There has been an error!', 'There has been an error in the Get Object function.', 'error');
        }
    }

    async handleSave() {
        this.savePressed = true;
        this.buttonsDisabled = true;

        let recordsToSave = this.searchResults.filter(asset => this.selectedAssets.includes(asset.objectId));
        let jsonToParse = JSON.stringify(recordsToSave);

        try {
            const saveResult = await saveAssetWrappers({ jsonToParse : jsonToParse, accountId : this.recordId});

            let savedMessage = '', unsavedMessage = '';
            let unsavedRecords;

            if(saveResult) {
                let propertyList = Object.getOwnPropertyNames(saveResult);

                for(let property of propertyList) {
                    savedMessage += saveResult[property] + ', item number ' + property + '.\n';
                }

                utility.showNotif('You have successfully inserted the following record(s):', savedMessage, 'success');

                unsavedRecords = recordsToSave.filter(unsavedAsset => !propertyList.includes(unsavedAsset.objectId));
            }

            if(unsavedRecords && unsavedRecords.length != 0) {
                for(let record of unsavedRecords) {
                    unsavedMessage += record.title + ', item number ' + record.objectId + '.\n';
                }
    
                utility.showNotif('The following duplicate record(s) were not saved: ', unsavedMessage, 'info');
            }

            if(!saveResult && !unsavedRecords) {
                for(let duplicate of recordsToSave) {
                    unsavedMessage += duplicate.title + ', item number ' + duplicate.objectId + '.\n';
                }

                utility.showNotif('The following duplicate records were not saved: ', unsavedMessage, 'info');
            }
        } catch(error) {
            utility.showNotif('There has been an error!', error, 'error');
        }
    }

    handleChange(event) {
        this.selectedAssets = event.detail.value;
        if(this.selectedAssets == false || this.selectedAssets == []) {
            this.buttonsDisabled = true;
        } else {
            this.buttonsDisabled = false;
        }
    }

    handleReset() {
        this.selectedAssets = undefined;
        this.buttonsDisabled = true;
    }
}