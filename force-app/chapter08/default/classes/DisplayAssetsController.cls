public with sharing class DisplayAssetsController {
    public static DisplayAssetsService service = new DisplayAssetsService();

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
}