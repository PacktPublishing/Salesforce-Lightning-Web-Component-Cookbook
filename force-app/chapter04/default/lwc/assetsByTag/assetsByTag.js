import { LightningElement, api } from 'lwc';
import returnTagsWithAssetsByAccount from '@salesforce/apex/AssetsByTagController.returnTagsWithAssetsByAccount';
import returnTagsWithAssetsWrappersByAccount from '@salesforce/apex/AssetsByTagController.returnTagsWithAssetsWrappersByAccount';

export default class AssetsByTag extends LightningElement {
    @api accountId;
    limit = 10;
    offset = 0;
    
    connectedCallback() {
        this.getTagsWithAssets();
        this.getTagsWithAssetsWrappers();
    }

    async getTagsWithAssets() {
        let tagsWithAssets = await returnTagsWithAssetsByAccount({ accountIdString : this.accountId, lim: this.limit, offset: this.offset });

        console.log('tagsWithAssets: ' + JSON.stringify(tagsWithAssets));
    }

    async getTagsWithAssetsWrappers() {
        let tagsWithAssetWrappers = await returnTagsWithAssetsWrappersByAccount({ accountIdString : this.accountId, lim: this.limit, offset: this.offset });

        console.log('tagsWithAssetWrappers: ' + JSON.stringify(tagsWithAssetWrappers));
    }

}