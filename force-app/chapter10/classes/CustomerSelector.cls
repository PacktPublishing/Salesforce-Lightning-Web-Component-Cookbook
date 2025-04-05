public with sharing class CustomerSelector extends Util_Query {
    private static final String SEARCH_CUSTOMERS_BY_ACCOUNT = 'SELECT Id, Name, TotalLifeTimeValue FROM Customer WHERE AccountId = :accountId AND Name Like \':searchTerm*\' ORDER BY Name ASC';

    public List<Customer> searchCustomersPerAccount(Id accountId, String searchTerm) {
        Map<String, Object> bindMap = new Map<String, Object>{
            'accountId' => accountId,
            'searchTerm' => String.escapeSingleQuotes(searchTerm)
        };

        List<Customer> queryResult = (List<Customer>) queryWithBinds(SEARCH_CUSTOMERS_BY_ACCOUNT, bindMap, AccessLevel.SYSTEM_MODE);
        
        return queryResult;
    }
}