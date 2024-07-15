public with sharing class Constituents extends Util_DML{
    public void upsertConstituents(List<Constituent__c> constituentsToUpsert) {
        try{
            upsertRecords(constituentsToUpsert, 'Constituent_Id__c');
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}