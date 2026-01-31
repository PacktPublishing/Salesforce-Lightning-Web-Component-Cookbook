public with sharing class ContactSelector extends Util_Query {
    @TestVisible private static final String GET_CONTACTS_PER_ACCOUNT = 'SELECT Id, Salutation, FirstName, LastName, Email, Phone, Title FROM Contact WHERE AccountId = :accountId ORDER BY CreatedDate DESC';

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
    public List<Contact> searchContacts(String searchTerm) {
        String userInput = '\'%' + searchTerm + '%\'';
        String contactSearchString = 'SELECT Id, Name, Title, Account.Name FROM Contact WHERE Name LIKE ' + userInput + ' ORDER BY Name ASC';

        List<Contact> queryResult = (List<Contact>) query(contactSearchString, AccessLevel.SYSTEM_MODE);
        
        return queryResult;
    }
}