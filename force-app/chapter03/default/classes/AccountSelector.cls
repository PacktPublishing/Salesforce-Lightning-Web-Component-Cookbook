public inherited sharing class AccountSelector extends Util_Query {
    @TestVisible private static final String TOP_TEN_ACCOUNTS_QUERY = 'SELECT Id, Name, Phone, BillingCity, BillingState, BillingCountry, Museum_Office__latitude__s, Museum_Office__longitude__s, AnnualRevenue FROM Account WHERE Museum_Office__latitude__s != null ORDER BY AnnualRevenue DESC NULLS LAST LIMIT 10';

    public List<Account> topTenAccountsByRevenue() {
        List<Account> queryResult = (List<Account>) query(TOP_TEN_ACCOUNTS_QUERY, AccessLevel.SYSTEM_MODE);

        if(queryResult.size() == 0) {
            return null;
        }
        
        return queryResult;
    }
}