@IsTest
public class Util_DMLMockProvider implements System.StubProvider {
    public Object handleMethodCall(Object stubbedObject, String stubbedMethodName, 
        Type returnType, List<Type> listOfParamTypes, List<String> listOfParamNames, 
        List<Object> listOfArgs) {
            switch on stubbedMethodName {
                when 'insertRecords' {
                    Account acctForInsert = new Account(Name = 'Account For Insert');

                    result acctSRone= new Result(true, Util_MockIdGenerator.getMockId(acctForInsert));
                    List<Database.SaveResult> srList = new List<Database.SaveResult>{ (Database.SaveResult) JSON.deserialize(JSON.serialize(acctSRone), Database.SaveResult.class)};
                    return srList;
                }
                when 'updateRecords' {
                    List<Account> accountsInParams = (List<Account>) listOfArgs[0];
                    Account acctToUpdate = accountsInParams[0];
                    result acctSRone = new Result(true, acctToUpdate.Id);
        
                    List<Database.SaveResult> srList = new List<Database.SaveResult>{ (Database.SaveResult) JSON.deserialize(JSON.serialize(acctSRone), Database.SaveResult.class)};
                    return srList;
                }
                when 'upsertRecords' {
                    List<Account> accountsInParams = (List<Account>) listOfArgs[0];
                    Account acctToUpsert = accountsInParams[0];
                    result acctSRone = new Result(true, acctToUpsert.Id);
        
                    List<Database.UpsertResult> srList = new List<Database.UpsertResult>{ (Database.UpsertResult) JSON.deserialize(JSON.serialize(acctSRone), Database.UpsertResult.class)};
                    return srList;
                }
                when 'deleteRecords' {
                    List<Account> accountsInParams = (List<Account>) listOfArgs[0];
                    Account acctToDelete = accountsInParams[0];
                    result acctSRone = new Result(true, acctToDelete.Id);
        
                    List<Database.SaveResult> srList = new List<Database.SaveResult>{ (Database.SaveResult) JSON.deserialize(JSON.serialize(acctSRone), Database.SaveResult.class)};
                    return srList;
                }
                when 'undeleteRecords' {
                    List<Account> accountsInParams = (List<Account>) listOfArgs[0];
                    Account acctToUndelete = accountsInParams[0];
                    result acctSRone = new Result(true, acctToUndelete.Id);
        
                    List<Database.SaveResult> srList = new List<Database.SaveResult>{ (Database.SaveResult) JSON.deserialize(JSON.serialize(acctSRone), Database.SaveResult.class)};
                    return srList;
                }
                when 'mergeRecords' {
                    Account accountInParams = (Account) listOfArgs[0];
                    result acctSRone = new Result(true, accountInParams.Id);
        
                    Database.MergeResult mr = (Database.MergeResult) JSON.deserialize(JSON.serialize(acctSRone), Database.MergeResult.class);
                    return mr;
                } 
                when else {
                    return null;
                }
            }
        }
        
    private class Result {
        Private Boolean success;
        Private String id;

        private Result(Boolean success, String id) {
            this.success = success;
            this.id = id;
        }
    }
}