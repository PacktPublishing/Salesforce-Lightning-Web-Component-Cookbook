public with sharing class DisplayAssetsController {
    @TestVisible private static DisplayAssetsService service = new DisplayAssetsService();

    /** Chapter 8 Methods */
    @AuraEnabled(cacheable=true)
    public static List<Asset> returnAssetsByAccount(String accountIdString, Integer lim, Integer offset){
        try {
            Id accountId = Id.valueOf(accountIdString);
            return service.getAssetsByAccount(accountId, lim, offset);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static Integer returnAssetCount(String accountIdString) {
        try {
            Id accountId = Id.valueOf(accountIdString);
            return service.getAssetCount(accountId);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /** Chapter 9 Method */
    @AuraEnabled
    public static void updateAssetWrappers(String jsonToParse) {
        try {
            List<DisplayAssetsService.DisplayAssetWrapper> assetWrappers = (List<DisplayAssetsService.DisplayAssetWrapper>) JSON.deserialize(jsonToParse, List<DisplayAssetsService.DisplayAssetWrapper>.Class);
            service.saveAssetWrappers(assetWrappers);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}