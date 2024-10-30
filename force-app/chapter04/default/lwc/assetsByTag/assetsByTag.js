import { LightningElement, api } from 'lwc';
import returnTagsWithAssetsByAccount from '@salesforce/apex/AssetsByTagController.returnTagsWithAssetsByAccount';
import returnTagsWithAssetsWrappersByAccount from '@salesforce/apex/AssetsByTagController.returnTagsWithAssetsWrappersByAccount';
import { COLUMNS_DEFINITION } from './assetsByTagColumns';
import Utilities from 'c/notifUtils';
let utility;

export default class AssetsByTag extends LightningElement {
    @api accountId;
    limit = 10;
    offset = 0;

    _tagsWithAssetsResult;
    _tagsWithAssetsPromiseResult;
    _tagsWithAssetsWrappersResult;

    gridColumns = COLUMNS_DEFINITION;
    gridData;

    get isLoaded() {
        return JSON.stringify(this._tagsWithAssetsResult) == JSON.stringify(this._tagsWithAssetsPromiseResult)
            &&
            JSON.stringify(this._tagsWithAssetsResult) == JSON.stringify(this._tagsWithAssetsWrappersResult);
    }
    
    connectedCallback() {
        utility = new Utilities(this);
        this.getTagsWithAssets();
        this.getTagsWithAssetsPromise();
        this.getTagsWithAssetsWrappers();
    }

    async getTagsWithAssets() {
        try{
            const tagsWithAssets = await returnTagsWithAssetsByAccount({ accountIdString : this.accountId, lim: this.limit, offset: this.offset });

            this._tagsWithAssetsResult = this.dataFlattener(tagsWithAssets);

            this.treeGridFormatter(this._tagsWithAssetsResult);
        } catch(error) {
            utility.showNotif('There has been an error in getTagsWithAssets!', error.message, 'error');
        }
    }

    getTagsWithAssetsPromise() {
        returnTagsWithAssetsByAccount({ accountIdString : this.accountId, lim: this.limit, offset: this.offset })
            .then(tagsWithAssets => {
                this._tagsWithAssetsPromiseResult = this.dataFlattener(tagsWithAssets);

                this.treeGridFormatter(this._tagsWithAssetsPromiseResult);

            })
            .catch(error => {
                utility.showNotif('There has been an error in getTagsWithAssetsPromise!', error.message, 'error');
            })
    }

    dataFlattener(dataToFlatten) {
        let flattenedData = [];

        for(let tag of dataToFlatten) {
            if(tag.Assets__r) {
                let flattenedAssets = tag.Assets__r.map((asset) => {
                    return ({
                        "assetDepartment" : asset.Department__c,
                        "assetId" : asset.Id,
                        "assetIsPublicDomain" : asset.Is_Public_Domain__c,
                        "assetName" : asset.Name,
                        "assetObjectId" : asset.Object_ID__c,
                        "assetPrimaryImage" : asset.Primary_Image__c,
                        "tagId" : tag.Id,
                        "tagName" : tag.Name
                    })
                });

                flattenedData = [...flattenedData, ...flattenedAssets];
            }
        }

        flattenedData.sort((a, b) => {
                return (a.assetName > b.assetName) ? 1 : -1;
            }
        );

        return flattenedData;
    }

    async getTagsWithAssetsWrappers() {
        try{
            const tagsWithAssetWrappers = await returnTagsWithAssetsWrappersByAccount({ accountIdString : this.accountId, lim: this.limit, offset: this.offset });

            let wrappersToSort = [...tagsWithAssetWrappers];

            let sortedWrappers = wrappersToSort.sort((a, b) => {
                    return (a.assetName > b.assetName) ? 1 : -1;
                }
            );

            this._tagsWithAssetsWrappersResult = sortedWrappers;

            this.treeGridFormatter(this._tagsWithAssetsWrappersResult);
        } catch(error) {
            utility.showNotif('There has been an error in getTagsWithAssetsWrappers!', error.message, 'error');
        }
    }

    treeGridFormatter(dataToFormat) {
        let tagArray = []
        for(let asset of dataToFormat) {
            let tagObject = {
                "tagName" : asset.tagName,
                "assetName" : '',
                "assetObjectId" : '',
                "assetIsPublicDomain" : '',
                "_children" : []
            }

            if(tagArray.find((objectToFind) => (objectToFind.tagName === tagObject.tagName)) == undefined) {
                tagArray.push(tagObject)
            }
            
            tagArray.find((objectToFind) => (objectToFind.tagName === tagObject.tagName))._children.push(asset);
        }

        tagArray.sort((a, b) => {
                return (a.tagName > b.tagName) ? 1 : -1;
            }
        );

        for(let tag of tagArray) {
            tag._children.sort((a, b) => {
                    return (a.assetName > b.assetName) ? 1 : -1;
                }
            );
        }

        this.gridData = tagArray;
    }
}