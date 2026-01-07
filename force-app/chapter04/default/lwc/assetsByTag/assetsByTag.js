import { LightningElement, api } from 'lwc';
import returnTagsWithAssetsByAccount from '@salesforce/apex/AssetsByTagController.returnTagsWithAssetsByAccount';
import returnTagsWithAssetsWrappersByAccount from '@salesforce/apex/AssetsByTagController.returnTagsWithAssetsWrappersByAccount';
import { COLUMNS_DEFINITION } from './assetsByTagColumns';
import Utilities from 'c/notifUtils';
let utility;

export default class AssetsByTag extends LightningElement {
    @api accountId;

    _tagsWithAssetsResult;
    _tagsWithAssetsPromiseResult;
    _tagsWithAssetsWrappersResult;

    gridColumns = COLUMNS_DEFINITION;
    gridData;

    get isLoaded() {
        return this.gridData;
    }
    
    connectedCallback() {
        utility = new Utilities(this);
        this.getTagsWithAssets();
    }

    @api
    async getTagsWithAssets() {
        try{
            const tagsWithAssets = await returnTagsWithAssetsByAccount({ accountIdString : this.accountId });

            this._tagsWithAssetsResult = this.assetFlattener(tagsWithAssets);

            return this.treeGridFormatter(this._tagsWithAssetsResult);
        } catch(error) {
            utility.showNotif('There has been an error in getTagsWithAssets!', error.message, 'error');
        }

        return this._tagsWithAssetsResult
    }

    getTagsWithAssetsPromise() {
        returnTagsWithAssetsByAccount({ accountIdString : this.accountId })
            .then(tagsWithAssets => {
                this._tagsWithAssetsPromiseResult = this.assetFlattener(tagsWithAssets);

                return this.treeGridFormatter(this._tagsWithAssetsPromiseResult);
            })
            .catch(error => {
                utility.showNotif('There has been an error in getTagsWithAssetsPromise!', error.message, 'error');
            })
    }

    @api
    assetFlattener(dataToFlatten) {
        let flattenedData = [];

        for(let tag of dataToFlatten) {
            if(tag.Assets__r) {
                let flattenedAssets = tag.Assets__r.map((asset) => {
                    return ({
                        'assetDepartment' : asset.Department__c,
                        'assetId' : asset.Id,
                        'assetIsPublicDomain' : asset.Is_Public_Domain__c,
                        'assetName' : asset.Name,
                        'assetObjectId' : asset.Object_ID__c,
                        'assetPrimaryImage' : asset.Primary_Image__c,
                        'tagId' : tag.Id,
                        'tagName' : tag.Name
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
            const tagsWithAssetsWrappers = await returnTagsWithAssetsWrappersByAccount({ accountIdString : this.accountId });

            let wrappersToSort = [...tagsWithAssetsWrappers];

            let sortedWrappers = wrappersToSort.sort((a, b) => {
                    return (a.assetName > b.assetName) ? 1 : -1;
                }
            );

            this._tagsWithAssetsWrappersResult = sortedWrappers;

            return this.treeGridFormatter(this._tagsWithAssetsWrappersResult);
        } catch(error) {
            utility.showNotif('There has been an error in getTagsWithAssetsWrappers!', error.message, 'error');
        }

        return this._tagsWithAssetsWrappersResult;
    }

    @api
    treeGridFormatter(dataToFormat) {
        let tagArray = [];
        for(let asset of dataToFormat) {
            let tagObject = {
                'tagName' : asset.tagName,
                'assetName' : '',
                'assetObjectId' : '',
                'assetIsPublicDomain' : '',
                '_children' : []
            }

            if(tagArray.find((objectToFind) => (objectToFind.tagName === tagObject.tagName)) === undefined) {
                tagArray.push(tagObject);
            }
            
            tagArray.find((objectToFind) => (objectToFind.tagName === tagObject.tagName))._children.push(asset);
        }

        tagArray.sort((a, b) => {
                return (a.tagName > b.tagName) ? 1 : -1;
            }
        );

        tagArray.forEach((tag) => {
            tag._children.sort((a, b) => {
                    return (a.assetName > b.assetName) ? 1 : -1;
                }
            );
        });

        this.gridData = [...tagArray];

        return this.gridData;
    }
}