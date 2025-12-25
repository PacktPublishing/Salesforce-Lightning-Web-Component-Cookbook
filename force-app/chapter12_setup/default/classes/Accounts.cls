public without sharing class Accounts extends Util_DML {
    public void updateAccounts(List<Account> accountsToUpdate) {
        try{
            updateRecords(accountsToUpdate);
        } catch (Exception e) {
            //error processing
        }
    }
}