public with sharing class AssetSelector extends Util_Query {
    public static final String assetsByAccount = 'SELECT Id, Name, Department__c, Description, Is_Public_Domain__c, Object_Id__c, Asset_URL__c, Primary_Image_Small__c FROM Asset WHERE AccountId = :accountId LIMIT :lim OFFSET :offset';

    public List<Asset> retrieveAssetsByAccount(Id accountId, Integer lim, Integer offset) {
        Map<String, Object> bindMap = new Map<String, Object>{
            'accountId' => accountId,
            'lim' => lim,
            'offset' => offset
        };

        List<Asset> queryResult = (List<Asset>) queryWithBinds(assetsByAccount, bindMap, AccessLevel.SYSTEM_MODE);
        
        return queryResult;
    }

    public Integer countAssets(Id accountId) {
        return [SELECT COUNT() FROM Asset WHERE AccountId = :accountId];
    }
}