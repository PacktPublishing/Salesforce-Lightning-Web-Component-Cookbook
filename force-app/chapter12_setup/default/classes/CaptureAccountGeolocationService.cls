public with sharing class CaptureAccountGeolocationService {
    @TestVisible private Accounts accounts = new Accounts();

    public void prepareAccountToUpdate(Id accountId, Decimal lat, Decimal lng) {
        Account accountToUpdate = new Account(
            Id = accountId,
            Museum_Office__latitude__s = lat,
            Museum_Office__longitude__s = lng
        );

        this.accounts.updateAccounts(new List<Account>{accountToUpdate});
    }
}