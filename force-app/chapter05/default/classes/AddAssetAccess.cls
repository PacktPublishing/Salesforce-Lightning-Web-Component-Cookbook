public with sharing class AddAssetAccess extends Util_DML {

    public String getDepartments() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:The_Met_Named/departments');
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        if(response.getStatusCode() == 200) {
            return response.getBody();
        }
        return null;
    }

    public String searchByTerm(String searchTerm, Integer departmentId) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:The_Met_Named/search?q=' + String.escapeSingleQuotes(searchTerm) + '&departmentId=' + departmentId);
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        if(response.getStatusCode() == 200) {
            return response.getBody();
        }
        return null;
    }

    public String getSearchedAssetInfo(Integer objectId) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:The_Met_Named/objects/' + objectId);
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        if(response.getStatusCode() == 200) {
            return response.getBody();
        }
        return null;
    }

    public void upsertConstituents(List<Constituent__c> constituentsToUpsert) {
        try{
            upsertRecords(constituentsToUpsert, 'Constituent_Id__c');
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public void upsertTags(List<Tag__c> tagsToUpsert) {
        try {
            upsertRecords(tagsToUpsert, 'AAT__c');
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

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