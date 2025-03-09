public with sharing class DisplayAssetsController {
    @AuraEnabled(cacheable=true)
    public static List<Asset> returnAssetsByAccount(String accountIdString, Integer lim, Integer offset){
        try {
            Id accountId = Id.valueOf(accountIdString);
            return new DisplayAssetsService().getAssetsByAccount(accountId, lim, offset);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static Integer returnAssetCount(String accountIdString) {
        try {
            Id accountId = Id.valueOf(accountIdString);
            return new DisplayAssetsService().getAssetCount(accountId);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}