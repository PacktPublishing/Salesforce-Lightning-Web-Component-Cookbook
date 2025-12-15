@IsTest
public class Util_QueryTest {
    @IsTest
    static void mockQueryTest() {
        Util_Query mockQuery = (Util_Query)Util_Mocker.createMock(Util_Query.class);
        
        String queryString = 'SELECT Id, Name FROM Account';

        Test.startTest();
            List<SObject> sobjList = mockQuery.query(queryString, AccessLevel.SYSTEM_MODE);
        Test.stopTest();

        Assert.areNotEqual(0, sobjList.size(), 'Verify that the size of the list of sObjects returned is not equal to zero.');
    }

    @IsTest
    static void queryTest() {
        Util_Query queryUtil = new Util_Query();

        Account acct = new Account(Name = 'Test Account');
        insert acct;
        
        String queryString = 'SELECT Id, Name FROM Account';

        Test.startTest();
            List<SObject> sobjList = queryUtil.query(queryString, AccessLevel.SYSTEM_MODE);
        Test.stopTest();

        Assert.areNotEqual(0, sobjList.size(), 'Verify that the size of the list of sObjects returned is not equal to zero.');
    }

    @IsTest
    static void mockQueryWithBindsTest() {
        Util_Query mockQuery = (Util_Query)Util_Mocker.createMock(Util_Query.class);
        
        String queryString = 'SELECT Id, Name FROM Account WHERE Name = :bindName';

        Map<String, Object> bindMap = new Map<String, Object> {
            'bindName' => 'Test Account'
        };

        Test.startTest();
            List<SObject> sobjList = mockQuery.queryWithBinds(queryString, bindMap, AccessLevel.SYSTEM_MODE);
        Test.stopTest();

        Assert.areNotEqual(0, sobjList.size(), 'Verify that the size of the list of sObjects returned is not equal to zero.');
    }

    @IsTest
    static void queryWithBindsTest() {
        Util_Query queryUtil = new Util_Query();

        Account acct = new Account(Name = 'Test Account');
        insert acct;
        
        String queryString = 'SELECT Id, Name FROM Account WHERE Name = :bindName';

        Map<String, Object> bindMap = new Map<String, Object> {
            'bindName' => 'Test Account'
        };

        Test.startTest();
            List<SObject> sobjList = queryUtil.queryWithBinds(queryString, bindMap, AccessLevel.SYSTEM_MODE);
        Test.stopTest();

        Assert.areNotEqual(0, sobjList.size(), 'Verify that the size of the list of sObjects returned is not equal to zero.');
    }

    @IsTest
    static void mockSearchTest() {
        Util_Query mockQuery = (Util_Query)Util_Mocker.createMock(Util_Query.class);
        
        String searchString = 'FIND {Test*} IN ALL FIELDS Returning Account(Id, Name)';

        Test.startTest();
            List<List<SObject>> sobjList = mockQuery.search(searchString, AccessLevel.SYSTEM_MODE);
        Test.stopTest();

        Assert.areNotEqual(0, sobjList.size(), 'Verify that the size of the list of sObjects returned is not equal to zero.');
   
    }

    @IsTest
    static void searchTest() {
        Util_Query queryUtil = new Util_Query();

        Account acct = new Account(Name = 'Test Account');
        insert acct;
        
        String searchString = 'FIND {Test*} IN ALL FIELDS Returning Account(Id, Name)';

        Test.startTest();
            List<List<SObject>> sobjList = queryUtil.search(searchString, AccessLevel.SYSTEM_MODE);
        Test.stopTest();

        Assert.areNotEqual(0, sobjList.size(), 'Verify that the size of the list of sObjects returned is not equal to zero.');
   
    }
}