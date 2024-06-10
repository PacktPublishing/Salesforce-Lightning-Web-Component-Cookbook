public inherited sharing class AccountSelector {

    Util_Query queryUtil = new Util_Query();
    private static final String TOP_TEN_ACCOUNTS_QUERY = 'SELECT Id, Name, Phone, BillingCity, BillingState, BillingCountry, AnnualRevenue FROM Account ORDER BY AnnualRevenue DESC NULLS LAST LIMIT 10';

    public List<AccountWrapper> topTenAccountsByRevenue() {
        List<Account> queryResult = (List<Account>) queryUtil.query(TOP_TEN_ACCOUNTS_QUERY);
        List<AccountWrapper> queriedWrappers = new List<AccountWrapper>();

        for(Account acct : queryResult) {
            queriedWrappers.add(new AccountWrapper(acct));
        }

        return queriedWrappers;
    }

    public class AccountWrapper {
        @AuraEnabled public String Id;
        @AuraEnabled public String Name;
        @AuraEnabled public String Phone;
        @AuraEnabled public String BillingCity;
        @AuraEnabled public String BillingState;
        @AuraEnabled public String BillingCountry;
        @AuraEnabled public Decimal AnnualRevenue;

        public AccountWrapper(Account acct) {
            this.Id = acct.Id;
            this.Name = acct.Name;
            this.Phone = acct.Phone;
            this.BillingCity = acct.BillingCity;
            this.BillingState = acct.BillingState;
            this.BillingCountry = acct.BillingCountry;
            this.AnnualRevenue = acct.AnnualRevenue;
        }
    }
}