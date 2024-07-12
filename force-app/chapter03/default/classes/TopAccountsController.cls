public with sharing class TopAccountsController {
    @AuraEnabled(cacheable=true)
    public static string returnAccountWrapperList(){
        try {
            List<AccountService.AccountWrapper> wrapsToStringify = new AccountService().getTopAccountWrappers();
            return wrapsToStringify == null ? null : JSON.serialize(wrapsToStringify);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}