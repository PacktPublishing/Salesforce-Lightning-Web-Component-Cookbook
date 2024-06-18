public with sharing class AccountService {
    @AuraEnabled(cacheable=true)
    public static string returnAccountWrapperList(){
        try {
            List<AccountSelector.AccountWrapper> wrapsToStringify = new AccountSelector().topTenAccountsByRevenue();
            return wrapsToStringify == null ? null : JSON.serialize(wrapsToStringify);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}