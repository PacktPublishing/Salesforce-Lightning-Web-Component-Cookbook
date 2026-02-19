public with sharing class DisplayAssetsService {
    /** Chapter 8 Variable */
    @TestVisible private AssetSelector selector = new AssetSelector();

    /** Chapter 9 & 10 Variables */
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
                Id consumerId = Id.valueOf(wrapper.consumerValue);

                Consumer_Inquiry__c newInquiry;
                Consumer newConsumer;
                switch on consumerId.getSObjectType().getDescribe().getName().toLowerCase() {
                    when 'contact' {
                        newConsumer = new ContactConsumer(wrapper.Id, new Contact(Id = consumerId));
                        newInquiry = newConsumer.getConsumerInquiry();
                    }
                    when 'customer' {
                        newConsumer = new CustomerConsumer(wrapper.Id, new Customer(Id = consumerId));
                        newInquiry = newConsumer.getConsumerInquiry();
                    }
                    when else {
                        continue;
                    }
                }
    
                inquiriesToInsert.add(newInquiry);
            }
        }


        this.inquiries.insertInquiries(inquiriesToInsert);
        this.assets.updateAssets(assetsToUpdate);
    }

    public class DisplayAssetWrapper {
        public String Id;
        public String statusValue;
        public String consumerValue;
    }
}