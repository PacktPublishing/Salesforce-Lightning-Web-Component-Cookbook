public with sharing class OrgSetupREST {

    @TestVisible private static final String AAT_URL_STRING = 'http://vocab.getty.edu/page/aat/';
    @TestVisible private static Util_DML dmlUtil = new Util_DML();

    @future(callout=true)
    public static void getAssets(Integer objectId, Id accountId) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:The_Met_Named/objects/' + objectId);
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        ObjectWrappers.AssetWrapper assetWrapper = (ObjectWrappers.AssetWrapper) JSON.deserialize(response.getBody(), ObjectWrappers.AssetWrapper.Class);

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

            try{
                dmlUtil.upsertRecords(new List<Constituent__c>{constituentToUpsert}, 'Constituent_Id__c');
            } catch (Exception e) {
                System.debug(e.getMessage());
            }
        }

        if(assetWrapper.tags != null) {
            tagToUpsert.Name = nullCheck(assetWrapper.tags[0].term);
            tagToUpsert.AAT__c = nullCheck(assetWrapper.tags[0].AAT_URL).removeStart(AAT_URL_STRING);
            tagToUpsert.AAT_URL__c = nullCheck(assetWrapper.tags[0].AAT_URL);
            tagToUpsert.Wikidata_URL__c = nullCheck(assetWrapper.tags[0].Wikidata_URL);
        } else {
            tagToUpsert.Name = 'No Tag Given';
            tagToUpsert.AAT__c = '99999';
        }

        Id upsertedTagId;

        try {
            Database.UpsertResult ur = dmlUtil.upsertRecords(new List<Tag__c>{tagToUpsert}, 'AAT__c')[0];

            upsertedTagId = ur.getId();
        } catch (Exception e) {
            System.debug(e.getMessage());
        }

        assetToUpsert.Accession_Number__c = assetWrapper.accessionNumber;
        assetToUpsert.Accession_Year__c = assetWrapper.accessionYear == '' ? null : Integer.valueOf(assetWrapper.accessionYear);
        assetToUpsert.Is_Public_Domain__c = assetWrapper.isPublicDomain;
        assetToUpsert.AccountId = accountId;
        assetToUpsert.Name = assetWrapper.title;
        assetToUpsert.Description = assetWrapper.creditLine;
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
        assetToUpsert.Tag__c = upsertedTagId;

        try{
            dmlUtil.upsertRecords(new List<Asset>{assetToUpsert}, 'Object_ID__c');
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
    }

    public static String nullCheck(String value) {
        return value == null ? 'Not Provided' : value;
    }
}