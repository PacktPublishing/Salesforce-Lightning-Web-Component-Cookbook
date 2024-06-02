public with sharing class AssetMapInterface {
    @AuraEnabled(cacheable=true)
    public static String getMapMarkers(String assetId) {
        try {
            return JSON.serialize(AssetMapAccess.getLocationWrappers(assetId));
        } catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}