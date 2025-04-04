public with sharing class AssetSelector extends Util_Query {
    private static final String ASSETS_BY_ACCOUNT = 'SELECT Id, Name, Department__c, Description, Is_Public_Domain__c, Object_Id__c, Asset_URL__c, Primary_Image_Small__c, Status__c FROM Asset WHERE AccountId = :accountId ORDER BY Name ASC LIMIT :lim OFFSET :offset';

    public List<Asset> retrieveAssetsByAccount(Id accountId, Integer lim, Integer offset) {
        Map<String, Object> bindMap = new Map<String, Object>{
            'accountId' => accountId,
            'lim' => lim,
            'offset' => offset
        };

        return (List<Asset>) queryWithBinds(ASSETS_BY_ACCOUNT, bindMap, AccessLevel.SYSTEM_MODE);
    }

    public Integer countAssets(Id accountId) {
        return [SELECT COUNT() FROM Asset WHERE AccountId = :accountId];
    }
}