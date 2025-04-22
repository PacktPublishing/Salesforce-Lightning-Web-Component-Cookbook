public with sharing class DisplayAssetsService {
    @TestVisible private AssetSelector selector = new AssetSelector();
    @TestVisible private Assets assets = new Assets();

    /** Chapter 8 Methods */
    public List<Asset> getAssetsByAccount(Id accountId, Integer lim, Integer offset){
        return this.selector.retrieveAssetsByAccount(accountId, lim, offset);
    }

    public Integer getAssetCount(Id accountId) {
        return this.selector.countAssets(accountId);
    }

    /** Chapter 9 & 10 Methods & Wrappers */
    public void saveAssetWrappers(List<DisplayAssetWrapper> wrapperList) {
        List<Asset> assetsToUpdate = new List<Asset>();

        for(DisplayAssetWrapper wrapper : wrapperList) {
            Asset assetToUpdate = new Asset(Id = wrapper.Id, Status = wrapper.Status);
            // Id idToUse = Id.valueOf(wrapper.contactOrCustomerId);

            // if(idToUse.getSObjectType().getDescribe().getName() == 'Contact') {
            //     assetToUpdate.ContactId = idToUse;
            // } else if(idToUse.getSObjectType().getDescribe().getName() == 'Customer') {
            //     assetToUpdate.Customer__c = idToUse;
            // }

            assetsToUpdate.add(assetToUpdate);
        }

        this.assets.updateAssets(assetsToUpdate);
    }

    public class DisplayAssetWrapper {
        String Id;
        String Status;
        String contactOrCustomerId;
    }
}