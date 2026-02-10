@IsTest
public with sharing class Util_QueryMockProvider implements System.StubProvider {
    public Object handleMethodCall(Object stubbedObject, String stubbedMethodName, 
        Type returnType, List<Type> listOfParamTypes, List<String> listOfParamNames, 
        List<Object> listOfArgs) {
            Account acctToReturn = new Account(Name = 'Return Account');
            switch on stubbedMethodName {
                when 'query', 'queryWithBinds' {
                    return (List<SObject>) Test.createStubQueryRows(acctToReturn.getSObjectType(), new List<Map<String, Object>>{mockAccountMapGenerator(acctToReturn)});
                }
                when 'countQuery', 'countQueryWithBinds' {
                    return Test.createStubQueryRows(acctToReturn.getSObjectType(), new List<Map<String, Object>> {mockAccountMapGenerator(acctToReturn)}).size();
                }
                when 'search' {
                    List<SObject> acctList = (List<SObject>) Test.createStubQueryRows(acctToReturn.getSObjectType(), new List<Map<String, Object>> {mockAccountMapGenerator(acctToReturn)});

                    Contact contactToReturn = new Contact(LastName = 'Contact To Return');
                    Map<String, Object> contactMap = new Map<String, Object> {
                        'id' => Util_FakeIdGenerator.getFakeId(contactToReturn),
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

        public static Map<String, Object> mockAccountMapGenerator(Account acctToReturn) {
            return new Map<String, Object> {
                'id' => Util_FakeIdGenerator.getFakeId(acctToReturn),
                'Name' => acctToReturn.Name
            };
        }
}