public with sharing class AddAssetService {
    
    private static final String AAT_URL_STRING = 'http://vocab.getty.edu/page/aat/';
    private Assets assets = new Assets();
    private Constituents constituents = new Constituents();
    private Tags tags = new Tags();

    public DepartmentsWrapper getDepartmentWrappers() {
        return (DepartmentsWrapper) JSON.deserialize(AddAssetAPI.getDepartments(), DepartmentsWrapper.Class);
    }

    public List<ObjectWrappers.AssetWrapper> getSearchedAssets(String searchTerm, Integer departmentId) {
        SearchWrapper searchWrap = (SearchWrapper) JSON.deserialize(AddAssetAPI.searchByTerm(searchTerm, departmentId), SearchWrapper.Class);

        List<ObjectWrappers.AssetWrapper> assetWrapperList = new List<ObjectWrappers.AssetWrapper>();

        if(searchWrap.objectIDs != null) {
            for(Integer objId : searchWrap.objectIDs) {
                ObjectWrappers.AssetWrapper assetWrapper = (ObjectWrappers.AssetWrapper) JSON.deserialize(AddAssetAPI.getSearchedAssetInfo(objId), ObjectWrappers.AssetWrapper.Class);
                assetWrapperList.add(assetWrapper);
            }
    
            return assetWrapperList;
        }

        return null;
    }

    public ObjectWrappers.AssetWrapper getSearchedAssetWrapper(Integer objectId) {
        return (ObjectWrappers.AssetWrapper) JSON.deserialize(AddAssetAPI.getSearchedAssetInfo(objectId), ObjectWrappers.AssetWrapper.Class);
    }

    public Map<Integer, String> upsertAssetsAndReturnInfoMap(List<ObjectWrappers.AssetWrapper> assetWrappers, Id accountId) {
        List<Asset> assetsToUpsert = new List<Asset>();
        List<Constituent__c> constituentsToUpsert = new List<Constituent__c>();
        List<Tag__c> tagsToUpsert = new List<Tag__c>();

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
            } else {
                tagToUpsert.Name = 'No Tag Given';
                tagToUpsert.AAT__c = '99999';
    
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
            constituents.upsertConstituents(constituentsToUpsert);
        }

        if(tagsToUpsert.size() > 0) {
            tags.upsertTags(tagsToUpsert);
        }

        if(assetsToUpsert.size() > 0) {
            return assets.upsertAssetsAndReturnInfoMap(assetsToUpsert);
        }
        
        return null;
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