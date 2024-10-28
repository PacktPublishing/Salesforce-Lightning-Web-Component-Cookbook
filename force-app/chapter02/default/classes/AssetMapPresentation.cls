public with sharing class AssetMapPresentation {
    @AuraEnabled(cacheable=true)
    public static String getMapMarkers(String assetId) {
        try {
            return JSON.serialize(AssetMapService.getLocationWrappers(assetId));
        } catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}