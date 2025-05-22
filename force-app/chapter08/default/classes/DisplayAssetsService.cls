public with sharing class DisplayAssetsService {
    @TestVisible private AssetSelector selector = new AssetSelector();
    @TestVisible private Assets assets = new Assets();
    @TestVisible private ConsumerInquiries inquiries = new ConsumerInquiries();

    /** Chapter 8 Methods */
    public List<Asset> getAssetsByAccount(Id accountId, Integer lim, Integer offset){
        return this.selector.retrieveAssetsByAccount(accountId, lim, offset);
    }

    public Integer getAssetCount(Id accountId) {
        return this.selector.countAssets(accountId);
    }

    /** Chapter 9 & 10 Method & Wrapper */
    public void saveAssetWrappers(List<DisplayAssetWrapper> wrapperList) {
        List<Asset> assetsToUpdate = new List<Asset>();
        List<Consumer_Inquiry__c> inquiriesToInsert = new List<Consumer_Inquiry__c>();

        for(DisplayAssetWrapper wrapper : wrapperList) {
            if(wrapper.statusValue != null && wrapper.statusValue != '') {
                Asset assetToUpdate = new Asset(Id = wrapper.Id, Status = wrapper.statusValue);

                assetsToUpdate.add(assetToUpdate);
            }

            if(wrapper.consumerValue != null && wrapper.consumerValue != '') {
                Id idToUse = Id.valueOf(wrapper.consumerValue);

                Consumer_Inquiry__c newInquiry = new Consumer_Inquiry__c(Asset__c = wrapper.Id);

                if(idToUse.getSObjectType().getDescribe().getName() == 'Contact') {
                    newInquiry.Contact__c = idToUse;
                } else if(idToUse.getSObjectType().getDescribe().getName() == 'Customer') {
                    newInquiry.Customer__c = idToUse;
                }

                inquiriesToInsert.add(newInquiry);
            }
        }


        this.inquiries.insertInquiries(inquiriesToInsert);
        this.assets.updateAssets(assetsToUpdate);
    }

    public class DisplayAssetWrapper {
        String Id;
        String statusValue;
        String consumerValue;
    }
}