public with sharing class AssetsByTagController {
    @TestVisible private static AssetsByTagService assetsByTagService = new AssetsByTagService();

    @AuraEnabled(cacheable=true)
    public static List<Tag__c> returnTagsWithAssetsByAccount(String accountIdString){
        try {
            Id accountId = Id.valueOf(accountIdString);
            return assetsByTagService.getTagsWithAssetsByAccount(accountId);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<AssetsByTagService.AssetWrapperCh04> returnTagsWithAssetsWrappersByAccount(String accountIdString){
        try {
            Id accountId = Id.valueOf(accountIdString);
            return assetsByTagService.getTagsWithAssetsWrappersByAccount(accountId);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}