public with sharing class Assets extends Util_DML {
    public Map<Integer, String> upsertAssets(List<Asset> assetsToUpsert) {
        Map<Integer, String> assetInfoMap = new Map<Integer, String>();

        try{
            List<Database.upsertResult> upsertResults = upsertRecords(assetsToUpsert, 'Object_ID__c');

            List<Id> idList = new List<Id>();

            for(Database.upsertResult ur : upsertResults) {
                if(ur.isCreated() && ur.isSuccess()) {
                    idList.add(ur.getId());
                }
            }

            if(idList.size() > 0) {
                for(Asset ast : [SELECT Id, Name, Object_ID__c FROM Asset WHERE Id IN :idList]) {
                    assetInfoMap.put(Integer.valueOf(ast.Object_ID__c), ast.Name);
                }
            } else {
                return null;
            }
        } catch (Exception e) {
            //error processing
        }

        return assetInfoMap;
    }
}