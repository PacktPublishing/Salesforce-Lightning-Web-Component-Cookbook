public with sharing class ContactSelector extends Util_Query {
    private static final String GET_CONTACTS_PER_ACCOUNT = 'SELECT Id, Salutation, FirstName, LastName, Email, Phone, Title FROM Contact WHERE AccountId = :accountId ORDER BY CreatedDate DESC';

    public List<Contact> contactsPerAccount(Id accountId) {
        Map<String, Object> bindMap = new Map<String, Object>{'accountId' => accountId};

        List<Contact> queryResult = (List<Contact>) queryWithBinds(GET_CONTACTS_PER_ACCOUNT, bindMap, AccessLevel.SYSTEM_MODE);

        if(queryResult.size() == 0) {
            return null;
        }
        
        return queryResult;
    }
}