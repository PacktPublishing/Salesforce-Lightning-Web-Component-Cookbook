public with sharing class ContactSelector extends Util_Query {
    private static final String GET_FIVE_CONTACTS_PER_ACCOUNT = 'SELECT Id, Salutation, FirstName, LastName, Phone, Title FROM Contact WHERE AccountId = :accountId ORDER BY CreatedDate DESC LIMIT 5';

    public List<Contact> fiveContactsPerAccount(Id accountId) {
        Map<String, Object> bindMap = new Map<String, Object>{'accountId' => accountId};

        List<Contact> queryResult = (List<Contact>) queryWithBinds(GET_FIVE_CONTACTS_PER_ACCOUNT, bindMap, AccessLevel.SYSTEM_MODE);

        if(queryResult.size() == 0) {
            return null;
        }
        
        return queryResult;
    }
}