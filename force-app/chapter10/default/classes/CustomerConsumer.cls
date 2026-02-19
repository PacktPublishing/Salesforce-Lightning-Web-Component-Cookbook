public with sharing class CustomerConsumer extends Consumer {
    public Id assetId;
    public Id consumerId;
    public Customer consumer;

    public CustomerConsumer(Id assetId, SObject consumer) {
        this.assetId = assetId;
        this.consumerId = consumerId;
        this.consumer = (Customer) consumer;
    }

    public override String getFact() {
        return String.valueOf(this.consumer.TotalLifeTimeValue);
    }

    public override Consumer_Inquiry__c getConsumerInquiry() {
        return new Consumer_Inquiry__c(Asset__c = this.assetId, Customer__c = this.consumerId);
    }
}