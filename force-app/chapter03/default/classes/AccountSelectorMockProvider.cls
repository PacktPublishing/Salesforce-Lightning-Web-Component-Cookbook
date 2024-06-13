@IsTest
public with sharing class AccountSelectorMockProvider implements System.StubProvider {    
    public Object handleMethodCall(Object stubbedObject, String stubbedMethodName, 
        Type returnType, List<Type> listOfParamTypes, List<String> listOfParamNames, 
        List<Object> listOfArgs) {
            switch on stubbedMethodName {
                when 'topTenAccountsByRevenue' {
                    List<Map<String, Object>> accountMaps = new List<Map<String, Object>>();

                    for(Integer ii = 9; ii > -1; ii--) {
                        Account acct = new Account(Name = 'Account ' + ii);
                        Decimal annualRev = ii * 100000;

                        Map<String, Object> accountMap = new Map<String, Object> {
                            'Name' => acct.Name,
                            'AnnualRevenue' => annualRev,
                            'Phone' => '555-555-5555',
                            'BillingCity' => 'Denver',
                            'BillingState' => 'Colorado',
                            'BillingCountry' => 'USA',
                            'Museum_Office__latitude__s' => 37.790197,
                            'Museum_Office__longitude__s' => -122.396879
                        };

                        accountMaps.add(accountMap);
                    }
                    List<AccountSelector.AccountWrapper> wrappedAccounts = new List<AccountSelector.AccountWrapper>();
                    List<Account> acctsToWrap = (List<Account>) Test.createStubQueryRows(Account.getSObjectType(), accountMaps);
                    for (Account acct : acctsToWrap) {
                        wrappedAccounts.add(new AccountSelector.AccountWrapper(acct));
                    }

                    return wrappedAccounts;
                }
                when else {
                    return null;
                }
            }
        }
}