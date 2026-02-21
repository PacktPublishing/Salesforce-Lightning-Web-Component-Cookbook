public with sharing class ContactConsumer extends Consumer {
    public Id assetId;
    public Id consumerId;
    public Contact consumer;

    public ContactConsumer(Id assetId, SObject consumer) {
        this.assetId = assetId;
        this.consumerId = consumerId;
        this.consumer = (Contact) consumer;
    }

    public override String getFact() {
        return this.consumer.Account.Name;
    }

    public override Consumer_Inquiry__c getConsumerInquiry() {
        return new Consumer_Inquiry__c(Asset__c = this.assetId, Contact__c = this.consumerId);
    }
}