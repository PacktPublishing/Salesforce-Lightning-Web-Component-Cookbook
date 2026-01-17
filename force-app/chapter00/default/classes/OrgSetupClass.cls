public with sharing class OrgSetupClass {
    public static List<Integer> artToImportById = new List<Integer>{436528, 253348, 436535, 37297, 437449, 438817, 3497, 170430, 47958, 227934};

    //not best practice! ideally we check to see if the perm exists first
    public static void getPerms() {
        Id permSetId = [SELECT Id FROM PermissionSet WHERE Name= 'Named_Credential_Access'].Id;
        Id userId = UserInfo.getUserId();

        List<PermissionSetAssignment> assignedPerms = [SELECT Id FROM PermissionSetAssignment WHERE AssigneeId = :userId AND PermissionSet.Name = 'Named_Credential_Access'];

        if(assignedPerms.size() == 0) {
            PermissionSetAssignment psa = new PermissionSetAssignment(AssigneeId = userId, PermissionSetId = permSetId);

            insert psa;
        }
    }

    //better practice!
    public static void dataSetup() {
        //use a list which can return size == 0 so we don't throw an error accessing
        List<Account> setupAccounts = [SELECT Id FROM Account WHERE Name = 'Ultricies PC'];

        if(setupAccounts.size() == 0) {
            CsvReader.getAccounts();
            CsvReader.getCustomers();
        }

        try {
            Id acctId = [SELECT Id FROM Account WHERE Name = 'Ultricies PC' LIMIT 1].Id;

            //this is not best practice, so we add the checks to make sure we aren't going to hit limits
            if(artToImportById.size() < 100) {
                for(Integer intId : artToImportById) {
                    //calls the API, needs to be written this way because the Open Access API only accepts one objectId for query at a time
                    OrgSetupREST.getAssets(intId, acctId);
                }
            }
        } catch(Exception e) {
            throw new SetupException(e.getMessage());
        }
    }

    public class SetupException extends Exception {}
}