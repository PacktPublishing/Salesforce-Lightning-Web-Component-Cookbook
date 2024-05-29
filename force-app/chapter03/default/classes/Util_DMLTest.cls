@isTest
public with sharing class Util_DMLTest {
    private class DMLStub extends Util_DML {}

    @IsTest
    static void insertRecords(){
        Account acct = new Account(Name = 'Insertion Account');

        DMLStub stub = new DMLStub();

        Test.startTest();
            List<Database.SaveResult> srList = stub.insertRecords(new List<Account>{acct});
        Test.stopTest();

        Assert.areNotEqual(null, acct.Id);
    }

    @IsTest
    static void updateRecords(){
        Account acct = new Account(Name = 'Updating Account');
        insert acct;

        acct.Name = 'Updated Account';

        DMLStub stub = new DMLStub();

        Test.startTest();
            List<Database.SaveResult> srList = stub.updateRecords(new List<Account>{acct});
        Test.stopTest();

        Assert.areNotEqual(null, acct.Id);

        List<Account> rehydratedAccounts = [SELECT Id, Name FROM Account WHERE Name = 'Updated Account'];

        Assert.areEqual(1, rehydratedAccounts.size());
        Assert.areEqual(acct.Id, rehydratedAccounts[0].Id);
    }

    @IsTest
    static void upsertRecords(){
        Account acct = new Account(Name = 'Upsertion Account');

        DMLStub stub = new DMLStub();

        Test.startTest();
            List<Database.UpsertResult> urList = stub.upsertRecords(new List<Account>{acct}, 'Id');
        Test.stopTest();

        Assert.areNotEqual(null, acct.Id);
    }

    @IsTest
    static void deleteRecords(){
        Account acct = new Account(Name = 'Deletion Account');

        insert acct;

        DMLStub stub = new DMLStub();

        Test.startTest();
            List<Database.SaveResult> srList = stub.deleteRecords(new List<Account>{acct});
        Test.stopTest();

        Assert.areEqual(1, srList.size());
    }

    @IsTest
    static void undeleteRecords(){
        Account acct = new Account(Name = 'Deletion Account');

        insert acct;
        delete acct;

        DMLStub stub = new DMLStub();

        Test.startTest();
            List<Database.SaveResult> srList = stub.undeleteRecords(new List<Account>{acct});
        Test.stopTest();

        Assert.areEqual(1, srList.size());
    }

    @IsTest
    static void mergeRecords(){
        Account acctOne = new Account(Name = 'Merge Account 1');
        insert acctOne;

        Account acctTwo = new Account(Name = 'Merge Account 2');
        insert acctTwo;

        DMLStub stub = new DMLStub();

        Test.startTest();
            Database.MergeResult mr = stub.mergeRecords(acctOne, acctTwo);
        Test.stopTest();

        List<Account> rehydratedAccounts = [SELECT Id, Name FROM Account WHERE Name LIKE 'Merge Account%'];

        Assert.areEqual(1, rehydratedAccounts.size());
    }
}