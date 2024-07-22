public with sharing class ViewContactController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> returnFiveContactsPerAccount(String accountIdString){
        try {
            return new ContactService().getFiveContactsPerAccount(Id.valueOf(accountIdString));
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}