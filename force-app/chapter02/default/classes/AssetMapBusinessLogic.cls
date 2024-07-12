public with sharing class AssetMapBusinessLogic {
    public static List<LocationWrapper> getLocationWrappers(Id assetId) {
        List<LocationWrapper> mapMarkers = new List<LocationWrapper>();
        List<Asset_Residency__c> residencyList = AssetMapAccess.getResidencies(assetId);

        for(Asset_Residency__c residency : residencyList) {
            mapMarkers.add(new LocationWrapper(residency));
        }

        return mapMarkers;
    }

    public class LocationWrapper {
        @AuraEnabled public MarkerWrapper location;
        @AuraEnabled public String value;
        @AuraEnabled public String title;

        public LocationWrapper(Asset_Residency__c residency) {
            this.location = new MarkerWrapper(residency);
            this.title = residency.Resident_Account__r.Name;
            this.value = residency.Name;
        }
    }

    public class MarkerWrapper {
        @AuraEnabled public String Latitude;
        @AuraEnabled public String Longitude;

        public MarkerWrapper(Asset_Residency__c residency) {
            this.Latitude = String.valueOf(residency.Resident_Account__r.Museum_Office__Latitude__s);
            this.Longitude = String.valueOf(residency.Resident_Account__r.Museum_Office__Longitude__s);
        }
    }
}