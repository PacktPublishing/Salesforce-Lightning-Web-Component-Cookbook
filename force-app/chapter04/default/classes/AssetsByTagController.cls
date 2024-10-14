public with sharing class AssetsByTagController {
    @AuraEnabled(cacheable=true)
    public static List<Tag__c> returnTagsWithAssetsByAccount(String accountIdString, Integer lim, Integer offset){
        try {
            Id accountId = Id.valueOf(accountIdString);
            return new AssetsByTagService().getTagsWithAssetsByAccount(accountId, lim, offset);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<AssetsByTagService.TagWrapperCh04> returnTagsWithAssetsWrappersByAccount(String accountIdString, Integer lim, Integer offset){
        try {
            Id accountId = Id.valueOf(accountIdString);
            return new AssetsByTagService().getTagsWithAssetsWrappersByAccount(accountId, lim, offset);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}