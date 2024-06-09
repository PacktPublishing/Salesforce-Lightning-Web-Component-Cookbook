@IsTest
public class Util_DMLTest {

    @IsTest
    static void insertRecords() {
        Util_DML dml = new Util_DML();

        Account acct = new Account(Name = 'Account');

        Test.startTest();
            List<Database.SaveResult> srList = dml.insertRecords(new List<Account>{acct});
        Test.stopTest();

        Assert.areNotEqual(null, srList[0].getId(), 'Verify that the ID of the inserted account is not null.');
    }

    @IsTest
    static void insertMockRecords() {
        Util_DML mockDML = (Util_DML)Util_Mocker.createDMLMock(Util_DML.class);

        Account acct = new Account(Name = 'Account');

        Test.startTest();
            List<Database.SaveResult> srList = mockDML.insertRecords(new List<Account>{acct});
        Test.stopTest();

        Assert.areNotEqual(null, srList[0].getId(), 'Verify that the ID of the inserted account is not null.');
    }

    @IsTest
    static void updateRecords() {
        Util_DML dml = new Util_DML();

        Account acct = new Account(Name = 'Account');
        List<Database.SaveResult> srList = dml.insertRecords(new List<Account>{acct});

        Test.startTest();
            List<Database.SaveResult> updSrList = dml.updateRecords(new List<Account>{new Account(Id = srList[0].getId(), Name = 'Updated Account')});
        Test.stopTest();

        Assert.areEqual(srList[0].getId(), updSrList[0].getId(), 'Verify that the ID of the inserted account matches the ID of the updated account.');
    }

    @IsTest
    static void updateMockRecords() {
        Util_DML mockDML = (Util_DML)Util_Mocker.createDMLMock(Util_DML.class);

        Account acct = new Account(Name = 'Account');
        List<Database.SaveResult> srList = mockDML.insertRecords(new List<Account>{acct});

        Test.startTest();
            List<Database.SaveResult> updSrList = mockDML.updateRecords(new List<Account>{new Account(Id = srList[0].getId(), Name = 'Updated Account')});
        Test.stopTest();

        Assert.areEqual(srList[0].getId(), updSrList[0].getId(), 'Verify that the ID of the inserted account matches the ID of the updated account.');
    }

    @IsTest
    static void upsertRecords(){
        Util_DML dml = new Util_DML();

        Account acct = new Account(Name = 'Account');
        List<Database.SaveResult> srList = dml.insertRecords(new List<Account>{acct});

        Test.startTest();
            List<Database.UpsertResult> upsSrList = dml.upsertRecords(new List<Account>{new Account(Id = srList[0].getId(), Name = 'Updated Account')}, 'Id');
        Test.stopTest();

        Assert.areEqual(srList[0].getId(), upsSrList[0].getId(), 'Verify that the ID of the inserted account matches the ID of the upserted account.');
    }
    
    @IsTest
    static void upsertMockRecords(){
        Util_DML mockDML = (Util_DML)Util_Mocker.createDMLMock(Util_DML.class);

        Account acct = new Account(Name = 'Account');
        List<Database.SaveResult> srList = mockDML.insertRecords(new List<Account>{acct});

        Test.startTest();
            List<Database.UpsertResult> upsSrList = mockDML.upsertRecords(new List<Account>{new Account(Id = srList[0].getId(), Name = 'Updated Account')}, 'Id');
        Test.stopTest();

        Assert.areEqual(srList[0].getId(), upsSrList[0].getId(), 'Verify that the ID of the inserted account matches the ID of the upserted account.');
    }

    @IsTest
    static void deleteRecords(){
        Util_DML dml = new Util_DML();

        Account acct = new Account(Name = 'Account');
        List<Database.SaveResult> srList = dml.insertRecords(new List<Account>{acct});

        Test.startTest();
            List<Database.SaveResult> delSrList = dml.deleteRecords(new List<Account>{new Account(Id = srList[0].getId())});
        Test.stopTest();

        Assert.areEqual(srList[0].getId(), delSrList[0].getId(), 'Verify that the ID of the inserted account matches the ID of the deleted account.');
    }

    @IsTest
    static void deleteMockRecords(){
        Util_DML mockDML = (Util_DML)Util_Mocker.createDMLMock(Util_DML.class);

        Account acct = new Account(Name = 'Account');
        List<Database.SaveResult> srList = mockDML.insertRecords(new List<Account>{acct});

        Test.startTest();
            List<Database.SaveResult> delSrList = mockDML.deleteRecords(new List<Account>{new Account(Id = srList[0].getId())});
        Test.stopTest();

        Assert.areEqual(srList[0].getId(), delSrList[0].getId(), 'Verify that the ID of the inserted account matches the ID of the deleted account.');
    }

    @IsTest
    static void undeleteRecords(){
        Util_DML dml = new Util_DML();

        Account acct = new Account(Name = 'Account');
        List<Database.SaveResult> srList = dml.insertRecords(new List<Account>{acct});
        List<Database.SaveResult> delSrList = dml.deleteRecords(new List<Account>{new Account(Id = srList[0].getId())});

        Test.startTest();
            List<Database.SaveResult> undelSrList = dml.undeleteRecords(new List<Account>{new Account(Id = srList[0].getId())});
        Test.stopTest();

        Assert.areEqual(srList[0].getId(), undelSrList[0].getId(), 'Verify that the ID of the inserted account matches the ID of the undeleted account.');
    }

    @IsTest
    static void undeleteMockRecords(){
        Util_DML mockDML = (Util_DML)Util_Mocker.createDMLMock(Util_DML.class);

        Account acct = new Account(Name = 'Account');
        List<Database.SaveResult> srList = mockDML.insertRecords(new List<Account>{acct});
        List<Database.SaveResult> delSrList = mockDML.deleteRecords(new List<Account>{new Account(Id = srList[0].getId())});

        Test.startTest();
            List<Database.SaveResult> undelSrList = mockDML.undeleteRecords(new List<Account>{new Account(Id = srList[0].getId())});
        Test.stopTest();

        Assert.areEqual(srList[0].getId(), undelSrList[0].getId(), 'Verify that the ID of the inserted account matches the ID of the undeleted account.');
    }

    @IsTest
    static void mergeRecords(){
        Util_DML dml = new Util_DML();

        Account acctToMerge = new Account(Name = 'Account To Merge');
        Account acctIsDuplicate = new Account(Name = 'Account Is Duplicate');

        List<Database.SaveResult> srList = dml.insertRecords(new List<Account>{acctToMerge, acctIsDuplicate});

        Test.startTest();
            Database.MergeResult mr = dml.mergeRecords(acctToMerge, acctIsDuplicate);
        Test.stopTest();

        Assert.areEqual(acctToMerge.Id, mr.getId(), 'Verify that the ID of the account to merge is the account that survived.');
    }

    @IsTest
    static void mergeMockRecords(){
        Util_DML mockDML = (Util_DML)Util_Mocker.createDMLMock(Util_DML.class);

        Account acctToMerge = new Account(Name = 'Account To Merge');
        Account acctIsDuplicate = new Account(Name = 'Account Is Duplicate');

        List<Database.SaveResult> srList = mockDML.insertRecords(new List<Account>{acctToMerge, acctIsDuplicate});

        Test.startTest();
            Database.MergeResult mr = mockDML.mergeRecords(acctToMerge, acctIsDuplicate);
        Test.stopTest();

        Assert.areEqual(acctToMerge.Id, mr.getId(), 'Verify that the ID of the account to merge is the account that survived.');
    }
}