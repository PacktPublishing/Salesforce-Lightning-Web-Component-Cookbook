@isTest
public with sharing class Util_DMLMockProvider implements System.StubProvider {

    Util_DML testUtil;

    public Object handleMethodCall(Object stubbedObject, String stubbedMethodName, 
        Type returnType, List<Type> listOfParamTypes, List<String> listOfParamNames, 
        List<Object> listOfArgs) {
            Account accountOne = new Account();
            accountOne.Id = Util_MockIDGenerator.getMockId(accountOne.getSObjectType());

            Account accountTwo = new Account();
            accountTwo.Id = Util_MockIDGenerator.getMockId(accountTwo.getSObjectType());

            List<Account> accountList = new List<Account>{accountOne, accountTwo};

            switch on stubbedMethodName {
                when 'insertRecords' {
                    return testUtil.insertRecords(accountList);
                }
                when 'updateRecords' {
                    return testUtil.updateRecords(accountList);
                }
                when 'upsertRecords' {
                    return testUtil.upsertRecords(accountList, 'Id');
                }
                when 'deleteRecords' {
                    return testUtil.deleteRecords(accountList);
                }
                when 'undeleteRecords' {
                    return testUtil.undeleteRecords(accountList);
                }
                when 'mergeRecords' {
                    return testUtil.mergeRecords(accountOne, accountTwo);
                } when else {
                    return null;
                }
            }
        }
}