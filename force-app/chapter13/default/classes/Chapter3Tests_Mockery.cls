@IsTest
public with sharing class Chapter3Tests_Mockery {
    @IsTest
    static void controller_it_should_return_account_wrappers() {
        //prepare
        List<Account> accountsToReturn = new List<Account>();
        for(Integer ii = 0; ii < 10; ii++) {
            Account acct = new Account(Name = 'Account ' + ii);
            acct.AnnualRevenue = ii * 100000;
            acct.Museum_Office__Latitude__s = 37.790197;
            acct.Museum_Office__Longitude__s = -122.396879;
            accountsToReturn.add(acct);
        }

        //arrange
        Mock accountSelectorMock = Mock.forType(AccountSelector.class);
        MethodSpy topTenAccountsByRevenueSpy = accountSelectorMock.spyOn('topTenAccountsByRevenue');
        AccountService myAccountService = new AccountService();
        myAccountService.accountSelect = (AccountSelector) accountSelectorMock.stub;
        topTenAccountsByRevenueSpy.returnsOnce(accountsToReturn);

        //act
        List<AccountService.AccountWrapper> myWrappers = myAccountService.getTopAccountWrappers();

        //assert
        for(Integer jj; jj < 10; jj++) {
            Integer accountNumber = 9 - jj;
            AccountService.AccountWrapper currentWrapper = myWrappers[jj];
            Assert.isTrue(currentWrapper.Name.contains(String.valueOf(accountNumber)), 'Accounts should be in order.');
            Assert.isTrue(currentWrapper.AnnualRevenue == accountNumber * 100000, 'Accounts should have appropriate annual revenue.');
        }
    }

    @IsTest
    static void service_it_should_return_account_wrappers() {
        //prepare
        List<Account> accountsToReturn = new List<Account>();
        for(Integer ii = 0; ii < 10; ii++) {
            Account acct = new Account(Name = 'Account ' + ii);
            acct.AnnualRevenue = ii * 100000;
            acct.Museum_Office__Latitude__s = 37.790197;
            acct.Museum_Office__Longitude__s = -122.396879;
            
            accountsToReturn.add(acct);
        }

        //arrange
        Mock accountSelectorMock = Mock.forType(AccountSelector.class);
        MethodSpy topTenAccountsByRevenueSpy = accountSelectorMock.spyOn('topTenAccountsByRevenue');
        AccountService myAccountService = new AccountService();
        myAccountService.accountSelect = (AccountSelector) accountSelectorMock.stub;
        topTenAccountsByRevenueSpy.returnsOnce(accountsToReturn);

        Mock utilQueryMock = Mock.forType(Util_Query.class);
        MethodSpy querySpy = utilQueryMock.spyOn('query');
        AccountSelector myAccountSelector = new AccountSelector();
        querySpy.returnsOnce(accountsToReturn);

        //act
        String myWrapperJson = TopAccountsController.returnAccountWrapperList();

        //assert
        for(Integer jj; jj < 10; jj++) {
            Integer accountNumber = 9 - jj;
            Assert.isTrue(myWrapperJson.contains(String.valueOf(accountNumber)), 'Accounts should be in order.');
            Assert.isTrue(myWrapperJson.contains(String.valueOf(accountNumber * 100000)), 'Accounts should have appropriate annual revenue.');
        }
    }

    @IsTest
    static void selector_it_should_return_accounts() {
        //prepare
        List<Account> accountsToReturn = new List<Account>();
        for(Integer ii = 0; ii < 10; ii++) {
            Account acct = new Account(Name = 'Account ' + ii);
            acct.AnnualRevenue = ii * 100000;
            acct.Museum_Office__Latitude__s = 37.790197;
            acct.Museum_Office__Longitude__s = -122.396879;

            accountsToReturn.add(acct);
        }

        //arrange
        Mock utilQueryMock = Mock.forType(Util_Query.class);
        MethodSpy querySpy = utilQueryMock.spyOn('query');
        AccountSelector myAccountSelector = new AccountSelector();
        querySpy.returnsOnce(accountsToReturn);

        //act
        List<Account> myAccounts = myAccountSelector.topTenAccountsByRevenue();

        //assert
        for(Integer jj; jj < 10; jj++) {
            Integer accountNumber = 9 - jj;
            Account currentAccount = myAccounts[jj];
            Assert.isTrue(currentAccount.Name.contains(String.valueOf(accountNumber)), 'Accounts should be in order.');
            Assert.isTrue(currentAccount.AnnualRevenue == accountNumber * 100000, 'Accounts should have appropriate annual revenue.');
        }
    }
}