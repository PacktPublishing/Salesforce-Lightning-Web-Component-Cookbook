public with sharing class ConsumerInquiries extends Util_DML {
    public void insertInquiries(List<Consumer_Inquiry__c> inquiriesToInsert) {
        try{
            insertRecords(inquiriesToInsert);
        } catch (Exception e) {
            //error processing
        }
    }
}