public with sharing class AssetsByTagController {
    @AuraEnabled(cacheable=true)
    public static List<Tag__c> returnTagsWithAssetsByAccount(String accountIdString){
        try {
            Id accountId = Id.valueOf(accountIdString);
            return new AssetsByTagService().getTagsWithAssetsByAccount(accountId);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<AssetsByTagService.AssetWrapperCh04> returnTagsWithAssetsWrappersByAccount(String accountIdString){
        try {
            Id accountId = Id.valueOf(accountIdString);
            return new AssetsByTagService().getTagsWithAssetsWrappersByAccount(accountId);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}