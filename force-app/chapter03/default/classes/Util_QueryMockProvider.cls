@IsTest
public with sharing class Util_QueryMockProvider implements System.StubProvider {
    public Object handleMethodCall(Object stubbedObject, String stubbedMethodName, 
        Type returnType, List<Type> listOfParamTypes, List<String> listOfParamNames, 
        List<Object> listOfArgs) {
            switch on stubbedMethodName {
                when 'query', 'queryWithBinds' {
                    Account acctToReturn = new Account(Name = 'Account To Return');
                    Map<String, Object> accountMap = new Map<String, Object> {
                        'id' => Util_MockIdGenerator.getMockId(acctToReturn),
                        'Name' => acctToReturn.Name
                    };
                    return (List<SObject>) Test.createStubQueryRows(acctToReturn.getSObjectType(), new List<Map<String, Object>>{accountMap});
                }
                when 'countQuery', 'countQueryWithBinds' {
                    Account acctToReturn = new Account(Name = 'Account To Return');
                    Map<String, Object> accountMap = new Map<String, Object> {
                        'id' => Util_MockIdGenerator.getMockId(acctToReturn),
                        'Name' => acctToReturn.Name
                    };
                    return Test.createStubQueryRows(acctToReturn.getSObjectType(), new List<Map<String, Object>>{accountMap}).size();
                }
                when 'search' {
                    Account acctToReturn = new Account(Name = 'Account To Return');
                    Map<String, Object> accountMap = new Map<String, Object> {
                        'id' => Util_MockIdGenerator.getMockId(acctToReturn),
                        'Name' => acctToReturn.Name
                    };
                    List<SObject> acctList = (List<SObject>) Test.createStubQueryRows(acctToReturn.getSObjectType(), new List<Map<String, Object>>{accountMap});

                    Contact contactToReturn = new Contact(LastName = 'Contact To Return');
                    Map<String, Object> contactMap = new Map<String, Object> {
                        'id' => Util_MockIdGenerator.getMockId(contactToReturn),
                        'LastName' => contactToReturn.LastName
                    };
                    List<SObject> contactList = (List<SObject>) Test.createStubQueryRows(contactToReturn.getSObjectType(), new List<Map<String, Object>>{contactMap});

                    return new List<List<SObject>>{acctList, contactList};
                }
                when else {
                    return null;
                }
            }
        }
}