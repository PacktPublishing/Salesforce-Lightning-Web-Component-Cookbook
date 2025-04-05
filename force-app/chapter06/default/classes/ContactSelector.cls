public with sharing class ContactSelector extends Util_Query {
    private static final String GET_CONTACTS_PER_ACCOUNT = 'SELECT Id, Salutation, FirstName, LastName, Email, Phone, Title FROM Contact WHERE AccountId = :accountId ORDER BY CreatedDate DESC';
    private static final String SEARCH_CONTACTS_BY_ACCOUNT = 'SELECT Id, Name, Title, Account.Name FROM Contact WHERE AccountId = :accountId AND Name Like \':searchTerm*\' ORDER BY Name ASC';

    /** Chapter 6 Method */
    public List<Contact> contactsPerAccount(Id accountId) {
        Map<String, Object> bindMap = new Map<String, Object>{'accountId' => accountId};

        List<Contact> queryResult = (List<Contact>) queryWithBinds(GET_CONTACTS_PER_ACCOUNT, bindMap, AccessLevel.SYSTEM_MODE);

        if(queryResult.size() == 0) {
            return null;
        }
        
        return queryResult;
    }

    /** Chapter 10 Method */
    public List<Contact> searchContactsPerAccount(Id accountId, String searchTerm) {
        Map<String, Object> bindMap = new Map<String, Object>{
            'accountId' => accountId,
            'searchTerm' => String.escapeSingleQuotes(searchTerm)
        };

        List<Contact> queryResult = (List<Contact>) queryWithBinds(SEARCH_CONTACTS_BY_ACCOUNT, bindMap, AccessLevel.SYSTEM_MODE);
        
        return queryResult;
    }
}