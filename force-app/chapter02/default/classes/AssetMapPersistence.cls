public without sharing class AssetMapPersistence {
    public static List<Asset_Residency__c> getResidencies(Id assetId) {
        return [SELECT Id, Name, Resident_Account__r.Name, Resident_Account__r.Museum_Office__Latitude__s, Resident_Account__r.Museum_Office__Longitude__s FROM Asset_Residency__c WHERE Asset__c = :assetId ORDER BY CreatedDate DESC LIMIT 10];
    }
}