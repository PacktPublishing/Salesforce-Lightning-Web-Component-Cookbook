public with sharing class AssetRetrievalDatabase {

    private static final String AAT_URL_STRING = 'http://vocab.getty.edu/page/aat/';
    public static Util_DML dmlUtil = new Util_DML();

    public static DepartmentsWrapper getDepartments() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:The_Met_Named/departments');
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        if(response.getStatusCode() == 200) {
            DepartmentsWrapper departmentsWrap = (DepartmentsWrapper) JSON.deserialize(response.getBody(), DepartmentsWrapper.Class);

            return departmentsWrap;
        }
        return null;
    }

    public static List<ObjectWrappers.AssetWrapper> searchByTerm(String searchTerm, Integer departmentId) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:The_Met_Named/search?q=' + String.escapeSingleQuotes(searchTerm) + '&departmentId=' + departmentId);
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        if(response.getStatusCode() == 200) {
            SearchWrapper searchWrap = (SearchWrapper) JSON.deserialize(response.getBody(), SearchWrapper.Class);

            List<ObjectWrappers.AssetWrapper> assetWrapperList = new List<ObjectWrappers.AssetWrapper>();
    
            if(searchWrap.objectIDs != null) {
                for(Integer objId : searchWrap.objectIDs) {
                    assetWrapperList.add(getSearchedAssetInfo(objId));
                }
        
                return assetWrapperList;
            }
        }
        return null;
    }

    public static ObjectWrappers.AssetWrapper getSearchedAssetInfo(Integer objectId) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:The_Met_Named/objects/' + objectId);
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        if(response.getStatusCode() == 200) {
            ObjectWrappers.AssetWrapper assetWrapper = (ObjectWrappers.AssetWrapper) JSON.deserialize(response.getBody(), ObjectWrappers.AssetWrapper.Class);

            return assetWrapper;
        }
        return null;
    }

    public static Map<Integer, String> upsertAssets(List<ObjectWrappers.AssetWrapper> assetWrappers, Id accountId) {
        List<Asset> assetsToUpsert = new List<Asset>();
        List<Constituent__c> constituentsToUpsert = new List<Constituent__c>();
        List<Tag__c> tagsToUpsert = new List<Tag__c>();
        
        Map<Integer, String> assetInfoMap = new Map<Integer, String>();

        for(ObjectWrappers.AssetWrapper assetWrapper : assetWrappers) {
            Constituent__c constituentToUpsert = new Constituent__c();
            Tag__c tagToUpsert = new Tag__c();
            Asset assetToUpsert = new Asset();

            if(assetWrapper.constituents != null) {
                constituentToUpsert.Name = nullCheck(assetWrapper.constituents[0].name);
                constituentToUpsert.Constituent_Id__c = nullCheck(assetWrapper.constituents[0].constituentID);
                constituentToUpsert.Gender__c = nullCheck(assetWrapper.constituents[0].gender);
                constituentToUpsert.Role__c = nullCheck(assetWrapper.constituents[0].role);
                constituentToUpsert.ULAN_URL__c = nullCheck(assetWrapper.constituents[0].constituentULAN_URL);
                constituentToUpsert.Wikidata_URL__c = nullCheck(assetWrapper.constituents[0].constituentWikidata_URL);

                constituentsToUpsert.add(constituentToUpsert);
            }

            if(assetWrapper.tags != null) {
                tagToUpsert.Name = nullCheck(assetWrapper.tags[0].term);
                tagToUpsert.AAT__c = nullCheck(assetWrapper.tags[0].AAT_URL).removeStart(AAT_URL_STRING);
                tagToUpsert.AAT_URL__c = nullCheck(assetWrapper.tags[0].AAT_URL);
                tagToUpsert.Wikidata_URL__c = nullCheck(assetWrapper.tags[0].Wikidata_URL);

                tagsToUpsert.add(tagToUpsert);
            }

            assetToUpsert.Accession_Number__c = assetWrapper.accessionNumber;
            assetToUpsert.Accession_Year__c = assetWrapper.accessionYear == '' ? null : Integer.valueOf(assetWrapper.accessionYear);
            assetToUpsert.Is_Public_Domain__c = assetWrapper.isPublicDomain;
            assetToUpsert.AccountId = Id.valueOf(accountId);
            assetToUpsert.Name = assetWrapper.title;
            assetToUpsert.Asset_URL__c = assetWrapper.objectURL;
            assetToUpsert.Asset_Wikidata_URL__c = assetWrapper.objectWikidata_URL;
            assetToUpsert.Classification__c = assetWrapper.classification;
            assetToUpsert.Culture__c = assetWrapper.culture;
            assetToUpsert.Department__c = assetWrapper.department;
            assetToUpsert.Is_Highlight__c = assetWrapper.isHighlight;
            assetToUpsert.Medium__c = assetWrapper.medium;
            assetToUpsert.Object_ID__c = assetWrapper.objectId;
            assetToUpsert.Period__c = assetWrapper.period;
            assetToUpsert.Primary_Image__c = assetWrapper.primaryImage;
            assetToUpsert.Primary_Image_Small__c = assetWrapper.primaryImageSmall;
            assetToUpsert.Primary_Constituent__c = constituentToUpsert.Id;
            assetToUpsert.Tag__c = tagToUpsert.Id;

            assetsToUpsert.add(assetToUpsert);
        }

        if(constituentsToUpsert.size() > 0) {
            try{
                dmlUtil.upsertRecords(constituentsToUpsert, 'Constituent_Id__c');
            } catch (Exception e) {
                throw new AuraHandledException(e.getMessage());
            }    
        }

        if(tagsToUpsert.size() > 0) {
            try {
                dmlUtil.upsertRecords(tagsToUpsert, 'AAT__c');
            } catch (Exception e) {
                throw new AuraHandledException(e.getMessage());
            }
        }

        if(assetsToUpsert.size() > 0) {
            try{
                List<Database.upsertResult> upsertResults = dmlUtil.upsertRecords(assetsToUpsert, 'Object_ID__c');

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
        }

        return assetInfoMap;
    }

    public static String nullCheck(String value) {
        return value == null ? 'Not Provided' : value;
    }

    public class DepartmentsWrapper {
        public List<DepartmentWrapper> departments;
    }

    public class DepartmentWrapper {
        public Integer departmentId;
        public String displayName;
    }

    public class SearchWrapper {
        public Integer total;
        public List<Integer> objectIDs;
    }
}