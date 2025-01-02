import { LightningElement, api } from 'lwc';
import searchAssetWrappers from '@salesforce/apex/AddAssetController.searchAssetWrappers';
import saveAssetWrappers from '@salesforce/apex/AddAssetController.saveAssetWrappers';
import Utilities from 'c/notifUtils';
let utility;

export default class AddAssetPicker extends LightningElement {
    @api recordId;
    @api searchTerm;
    @api departmentId;
    assetsToReturn;
    searchResults = [];
    options;
    isLoaded = false;
    isNull = false;
    savePressed = false;
    buttonsDisabled = true;


    @api get selectedAssets() {
        return this.assetsToReturn;
    }

    connectedCallback() {
        utility = new Utilities(this);
        this.sendSearchApex();
    }

    get assetsLoaded() {
        return this.isLoaded && this.isNull !== true;
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
                    let srClone = {...sr, label:sr.title, value:sr.objectId};
                    this.searchResults.push(srClone);
                }

                this.searchResults.sort((a, b) => {
                        return (a.label > b.label) ? 1 : -1;
                    }
                );

                this.options = this.searchResults;
            }
        } catch(error) {
            this.options = undefined;
            utility.showNotif('There has been an error in sendSearchApex!', error, 'error');
        }
        this.isLoaded = true;
    }

    sendSearchFetchAPI() {
        fetch('https://collectionapi.metmuseum.org/public/collection/v1/search?q=' + JSON.stringify(this.searchTerm).slice(1, -1) + '&departmentId=' + this.departmentId)
            .then(sendSearchFetch => {
                return sendSearchFetch.json();
            })
            .then(sendSearchResponse => {
                if(sendSearchResponse.objectIDs == null) {
                    Promise.resolve(this.isNull = true);
                }
                return this.searchObjects(sendSearchResponse.objectIDs);
            })
            .then(searchResults => {
                this.searchResults = searchResults;
                this.searchResults.sort((a, b) => {
                        return (a.label > b.label) ? 1 : -1;
                    }
                );
                
                this.options = this.searchResults;
                this.isLoaded = true;
            })
            .catch(error => {
                utility.showNotif('There has been an error in sendSearchFetchAPI!', error.message, 'error');
            });
    }

    searchObjects(objectIds) {
        return Promise.all(objectIds.map(objectId => {
            let object = this.getObject(objectId)
                .then(returnedObject => {
                    return returnedObject;
                })
                .catch(error => {
                    utility.showNotif('There has been an error in searchObjects!', error.message, 'error');
                });
            return object;
        }));
    }

    getObject(objectId) {
        return fetch('https://collectionapi.metmuseum.org/public/collection/v1/objects/' + objectId)
            .then(objectFetch => {
                return objectFetch.json();
            })
            .then(objectJSON => {
                let objectClone = {...objectJSON, label:objectJSON.title, value:objectJSON.objectID.toString()};
                return objectClone;
            })
            .catch(error => {
                    utility.showNotif('There has been an error in getObject!', error.message, 'error');
            });
    }

    async handleSave() {
        this.savePressed = true;
        this.buttonsDisabled = true;

        let recordsToSave = this.searchResults.filter(asset => this.assetsToReturn.includes(asset.value));

        let jsonToParse = JSON.stringify(recordsToSave);

        try {
            const savedRecords = await saveAssetWrappers({ jsonToParse : jsonToParse, accountId : this.recordId});
            let savedMessage = '';
            let unsavedMessage = '';
            let duplicateRecords = [];

            if(savedRecords == null) {
                duplicateRecords = recordsToSave;
            } else {
                let propertyList = Object.getOwnPropertyNames(savedRecords);

                for(let property of propertyList) {
                    savedMessage += savedRecords[property] + ', item number ' + property + '.\n';
                }

                duplicateRecords = recordsToSave.filter(record => !propertyList.includes(record.objectId));

                utility.showNotif('You have successfully inserted the following record(s):', savedMessage, 'success');
            }

            if(duplicateRecords.length > 0) {
                for(let record of duplicateRecords) {
                    unsavedMessage += record.label + ', item number ' + record.value + '.\n';
                }
    
                utility.showNotif('The following duplicate record(s) were not saved: ', unsavedMessage, 'info');    
            }
        } catch(error) {
            utility.showNotif('There has been an error in handleSave!', error.message, 'error');
        }
    }

    handleChange(event) {
        this.assetsToReturn = event.detail.value;
        if(this.assetsToReturn === false || this.assetsToReturn == []) {
            this.buttonsDisabled = true;
        } else {
            this.buttonsDisabled = false;
        }
    }

    handleReset() {
        this.assetsToReturn = undefined;
        this.buttonsDisabled = true;
    }
}