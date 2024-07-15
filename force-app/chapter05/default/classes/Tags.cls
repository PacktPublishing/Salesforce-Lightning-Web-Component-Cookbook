public with sharing class Tags extends Util_DML {
    public void upsertTags(List<Tag__c> tagsToUpsert) {
        try {
            upsertRecords(tagsToUpsert, 'AAT__c');
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}