@IsTest
public class Util_DMLMockProvider implements System.StubProvider {

    public Object handleMethodCall(Object stubbedObject, String stubbedMethodName, 
        Type returnType, List<Type> listOfParamTypes, List<String> listOfParamNames, 
        List<Object> listOfArgs) {
            Account acctForInsertOne = new Account(Name = 'Account For Insert One');
            Account acctForInsertTwo = new Account(Name = 'Account For Insert Two');

            Account acctWithIDOne = new Account(Name = 'Account With ID One', Id = Util_MockIdGenerator.getMockId(acctForInsertOne));
            Account acctWithIDTwo = new Account(Name = 'Account With ID Two', Id = Util_MockIdGenerator.getMockId(acctForInsertTwo));

            switch on stubbedMethodName {
                when 'insertRecords' {
                    result acctSRone= new result(true, Util_MockIdGenerator.getMockId(acctForInsertOne));
                    List<Database.SaveResult> srList = new List<Database.SaveResult>{ (Database.SaveResult) JSON.deserialize(JSON.serialize(acctSRone), Database.SaveResult.class)};
                    return srList;
                }
                when 'updateRecords' {
                    List<Account> accountsInParams = (List<Account>) listOfArgs[0];
                    Account acctToUpdate = accountsInParams[0];
                    result acctSRone = new result(true, acctToUpdate.Id);
        
                    List<Database.SaveResult> srList = new List<Database.SaveResult>{ (Database.SaveResult) JSON.deserialize(JSON.serialize(acctSRone), Database.SaveResult.class)};
                    return srList;
                }
                when 'upsertRecords' {
                    List<Account> accountsInParams = (List<Account>) listOfArgs[0];
                    Account acctToUpsert = accountsInParams[0];
                    result acctSRone = new result(true, acctToUpsert.Id);
        
                    List<Database.UpsertResult> srList = new List<Database.UpsertResult>{ (Database.UpsertResult) JSON.deserialize(JSON.serialize(acctSRone), Database.UpsertResult.class)};
                    return srList;
                }
                when 'deleteRecords' {
                    List<Account> accountsInParams = (List<Account>) listOfArgs[0];
                    Account acctToDelete = accountsInParams[0];
                    result acctSRone = new result(true, acctToDelete.Id);
        
                    List<Database.SaveResult> srList = new List<Database.SaveResult>{ (Database.SaveResult) JSON.deserialize(JSON.serialize(acctSRone), Database.SaveResult.class)};
                    return srList;
                }
                when 'undeleteRecords' {
                    List<Account> accountsInParams = (List<Account>) listOfArgs[0];
                    Account acctToUndelete = accountsInParams[0];
                    result acctSRone = new result(true, acctToUndelete.Id);
        
                    List<Database.SaveResult> srList = new List<Database.SaveResult>{ (Database.SaveResult) JSON.deserialize(JSON.serialize(acctSRone), Database.SaveResult.class)};
                    return srList;
                }
                when 'mergeRecords' {
                    Account accountInParams = (Account) listOfArgs[0];
                    result acctSRone = new result(true, accountInParams.Id);
        
                    Database.MergeResult mr = (Database.MergeResult) JSON.deserialize(JSON.serialize(acctSRone), Database.MergeResult.class);
                    return mr;
                } 
                when else {
                    return null;
                }
            }
        }
        
    private class result {
        Private Boolean success;
        Private String id;

        private result(Boolean success, String id) {
            this.success = success;
            this.id = id;
        }
    }
}