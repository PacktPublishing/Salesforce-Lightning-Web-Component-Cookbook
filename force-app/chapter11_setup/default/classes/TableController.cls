public with sharing class TableController {
    @TestVisible private static TableService tableService = new TableService();

    @AuraEnabled(cacheable=true)
    public static List<Account> returnTopTenAccounts() {
        try {
            return tableService.retrieveTopTenAccounts();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}