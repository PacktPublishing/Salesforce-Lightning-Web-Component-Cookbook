import { LightningElement, api } from 'lwc';
import searchAssetWrappers from '@salesforce/apex/AddAssetController.searchAssetWrappers';
import saveAssetWrappers from '@salesforce/apex/AddAssetController.saveAssetWrappers';
import Utilities from 'c/notifUtils';
let utility;

export default class AddAssetPicker extends LightningElement {
    @api recordId;
    @api searchTerm;
    @api departmentId;
    @api searchResultsJSON;
    searchResults = [];
    @api selectedAssets = [];
    options = [];
    isLoaded = false;
    isNull = false;
    savePressed = false;
    buttonsDisabled = true;

    connectedCallback() {
        utility = new Utilities(this);
        this.sendSearch();
    }

    get assetsLoaded() {
        return this.isLoaded && this.isNull != true;
    }

    get listDisabled() {
        return this.savePressed;
    }

    async sendSearch() {
        try {
            const data = await searchAssetWrappers( {search : this.searchTerm, departmentId : this.departmentId} );
            this.searchResultsJSON = data;

            if(this.searchResultsJSON == null) {
                this.isNull = true;
            } else {
                let temp = JSON.parse(data);
                
                for(let tmp of temp) {
                    let tmpClone = {...tmp, label:tmp.title, value:tmp.objectId};
                    this.searchResults.push(tmpClone);
                }

                this.searchResults.sort((a, b) => a.label - b.label);

                this.options = JSON.parse(JSON.stringify(this.searchResults));
            }
        } catch(error) {
            this.error = error;
            this.options = undefined;
            utility.showNotif('There has been an error!', this.error, 'error');
        }
        this.isLoaded = true;
    }

    async handleSave() {
        this.savePressed = true;
        this.buttonsDisabled = true;

        let recordsToSave = this.searchResults.filter(asset => this.selectedAssets.includes(asset.objectId));
        let jsonToParse = JSON.stringify(recordsToSave);
        console.log(JSON.stringify(recordsToSave));

        try {
            const saveResult = await saveAssetWrappers({ jsonToParse : jsonToParse, accountId : this.recordId});

            console.log('saveResult' + JSON.stringify(saveResult));

            let savedMessage = '', unsavedMessage = '';
            let unsavedRecords;

            if(saveResult) {
                console.log('option one!');
                let propertyList = Object.getOwnPropertyNames(saveResult);

                for(let property of propertyList) {
                    savedMessage += saveResult[property] + ', item number ' + property + '.\n';
                }

                utility.showNotif('You have successfully inserted the following record(s):', savedMessage, 'success');

                unsavedRecords = recordsToSave.filter(unsavedAsset => !propertyList.includes(unsavedAsset.objectId));  
                console.log('unsavedRecords ' + JSON.stringify(unsavedRecords));
            }

            if(unsavedRecords && unsavedRecords.length != 0) {
                console.log('option two!');
                for(let record of unsavedRecords) {
                    unsavedMessage += record.title + ', item number ' + record.objectId + '.\n';
                }
    
                utility.showNotif('The following duplicate record(s) were not saved: ', unsavedMessage, 'info');
            }

            if(!saveResult && !unsavedRecords) {
                console.log('option three!');
                for(let duplicate of recordsToSave) {
                    unsavedMessage += duplicate.title + ', item number ' + duplicate.objectId + '.\n';
                }

                utility.showNotif('The following duplicate records were not saved: ', unsavedMessage, 'info');
            }
        } catch(error) {
            this.error = error;
            utility.showNotif('There has been an error!', this.error, 'error');
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