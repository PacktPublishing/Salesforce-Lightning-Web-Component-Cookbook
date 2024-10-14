public with sharing class OrgSetupClass {
    public static List<Integer> artToImportById;

    public OrgSetupClass() {
        artToImportById = new List<Integer>{436528, 253348, 436535, 37297, 437449, 438817, 3497, 170430, 47958, 227934};
    }

    public OrgSetupClass(List<Integer> idsToImport) {
        if(idsToImport.size() > 99) {
            throw new SetupException('Please place less than 99 IDs in artToImportById.');
        } else if(idsToImport.size() == 0) {
            throw new SetupException('Please place at least 1 ID in artToImportById.');
        } else {
            artToImportById = idsToImport;
        }
    }

    public void initialSetup() {
        Id acctId = [SELECT Id FROM Account WHERE Name = 'Velit Eget Limited' LIMIT 1].Id;
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