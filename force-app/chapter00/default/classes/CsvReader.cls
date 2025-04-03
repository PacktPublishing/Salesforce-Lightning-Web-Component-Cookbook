public class CsvReader {
    public static void getAccounts() {
        String accountsToLoad = [SELECT Id, Body FROM StaticResource WHERE Name = 'AccountsToLoad'].Body.toString();

        DataWeave.Script dwscript = DataWeave.Script.createScript('csvToAccounts');
        DataWeave.Result dwresult = dwscript.execute(new Map<String, Object>{'records' => accountsToLoad});
        List<Account> results = (List<Account>)dwresult.getValue();

        insert results;

        getContacts(results);
    }

    public static void getContacts(List<Account> accountResults) {
        String contactsToLoad = [SELECT Id, Body FROM StaticResource WHERE Name = 'ContactsToLoad'].Body.toString();

        DataWeave.Script dwscript = DataWeave.Script.createScript('csvToContacts');
        DataWeave.Result dwresult = dwscript.execute(new Map<String, Object>{'records' => contactsToLoad});
        List<Contact> results = (List<Contact>)dwresult.getValue();

        for(Integer ii = 0; ii < accountResults.size(); ii++) {
            Contact con = results[ii];
            con.AccountId = accountResults[ii].Id;
        }

        insert results;
    }

    public static void getCustomers() {
        String customersToLoad = [SELECT Id, Body FROM StaticResource WHERE Name = 'CustomersToLoad'].Body.toString();

        DataWeave.Script dwscript = DataWeave.Script.createScript('csvToCustomers');
        DataWeave.Result dwresult = dwscript.execute(new Map<String, Object>{'records' => customersToLoad});
        List<Customer> results = (List<Customer>)dwresult.getValue();

        insert results;
    }
}