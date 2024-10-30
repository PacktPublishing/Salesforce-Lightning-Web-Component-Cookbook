public with sharing class Tags extends Util_DML {
    public List<Database.UpsertResult> upsertTags(List<Tag__c> tagsToUpsert) {
        try {
            return upsertRecords(tagsToUpsert, 'AAT__c');
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}