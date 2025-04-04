public with sharing class OrgSetupClass {
    public static List<Integer> artToImportById;

    public OrgSetupClass() {
        artToImportById = new List<Integer>{436528, 253348, 436535, 37297, 437449, 438817, 3497, 170430, 47958, 227934};
    }

    public void getPerms() {
        Id permSetId = [SELECT Id FROM PermissionSet WHERE Name= 'Named_Credential_Access'].Id;
        Id userId = UserInfo.getUserId();

        List<PermissionSetAssignment> assignedPerms = [SELECT Id FROM PermissionSetAssignment WHERE AssigneeId = :userId AND PermissionSet.Name = 'Named_Credential_Access'];

        if(assignedPerms.size() == 0) {
            PermissionSetAssignment psa = new PermissionSetAssignment(AssigneeId = userId, PermissionSetId = permSetId);

            insert psa;
        }
    }

    public void dataSetup() {
        CsvReader.getAccounts();
        CsvReader.getCustomers();

        Id acctId = [SELECT Id FROM Account WHERE Name = 'Ultricies PC' LIMIT 1].Id;
        //this is not best practice, so we add the constructor checks to make sure we aren't going to hit limits
        for(Integer intId : artToImportById) {
            OrgSetupREST.getAssets(intId, acctId);
        }
    }

    public static void addAsset(Integer assetId, Id acctId) {
        if(isAccountId(acctId)) {
            OrgSetupREST.getAssets(assetId, acctId);
        }
    }

    public static Boolean isAccountId(Id idToCheck) {
        if(idToCheck.getSobjectType().getDescribe().getName() != 'Account') {
            throw new SetupException('Please use an AccountId here.');
        }
        return true;
    }

    public class SetupException extends Exception {}
}