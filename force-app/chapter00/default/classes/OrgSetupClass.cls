public with sharing class OrgSetupClass {
    public static List<String> artToImportById = new List<String>{'436528', '253348', '436535', '37297', '437449', '438817', '3497', '170430', '47958', '227934'};

    public static void initialSetup(Id accountId) {
        if(accountId.getSobjectType().getDescribe().getName() != 'Account') {
            System.debug('Please use an Account Id as a parameter for this method.');
            return;
        } else if(artToImportById.size() > 99) {
            System.debug('Please use less than 99 Object IDs to avoid hitting limits.');
            return;
        } else {
            //this is not best practice, so we add the previous check to make sure we aren't going to hit limits
            for(String str : artToImportById) {
                OrgSetupREST.getAssets(str, accountId);
            }    
        }
    }

    public static void addAsset(Integer assetId, Id accountId) {
        if(accountId.getSobjectType().getDescribe().getName() != 'Account') {
            System.debug('Please use an Account Id as a parameter for this method.');
            return;
        }

        OrgSetupREST.getAssets(String.valueOf(assetId), accountId);
    }
}