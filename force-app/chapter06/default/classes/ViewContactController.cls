public with sharing class ViewContactController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> returnContactsPerAccount(String accountIdString){
        try {
            return new ContactService().getContactsPerAccount(Id.valueOf(accountIdString));
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}