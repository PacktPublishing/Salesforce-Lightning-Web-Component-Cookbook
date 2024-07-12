public with sharing class AssetMapPresentation {
    @AuraEnabled(cacheable=true)
    public static String getMapMarkers(String assetId) {
        try {
            return JSON.serialize(AssetMapBusinessLogic.getLocationWrappers(assetId));
        } catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}