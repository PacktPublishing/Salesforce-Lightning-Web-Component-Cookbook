public with sharing class AccountService {
    @AuraEnabled(cacheable=true)
    public static string returnAccountWrapperList(){
        try {
            return JSON.serialize(new AccountSelector().topTenAccountsByRevenue());
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}