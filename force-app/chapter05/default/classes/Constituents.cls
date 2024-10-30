public with sharing class Constituents extends Util_DML{
    public List<Database.UpsertResult> upsertConstituents(List<Constituent__c> constituentsToUpsert) {
        try{
            return upsertRecords(constituentsToUpsert, 'Constituent_Id__c');
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}