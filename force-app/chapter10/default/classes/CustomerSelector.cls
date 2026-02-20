public with sharing class CustomerSelector extends Util_Query {
    public List<Customer> searchCustomers(String searchTerm) {
        String userInput = '\'%' + String.escapeSingleQuotes(searchTerm) + '%\'';
        String customerSearchString = 'SELECT Id, Name, TotalLifeTimeValue FROM Customer WHERE Name LIKE '+ userInput + ' ORDER BY Name ASC';
        List<Customer> queryResult = (List<Customer>) query(customerSearchString, AccessLevel.SYSTEM_MODE);
        
        return queryResult;
    }
}