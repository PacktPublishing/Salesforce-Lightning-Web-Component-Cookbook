public with sharing class TableService {
    @TestVisible private AccountSelector acctSelect = new AccountSelector();

    public List<Account> retrieveTopTenAccounts() {
        return acctSelect.topTenAccountsByRevenue();
    } 
}