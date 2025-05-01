public with sharing class AssetSelector extends Util_Query {
    @TestVisible private static final String ASSETS_BY_ACCOUNT = 'SELECT Name, Department__c, Description, Is_Public_Domain__c, Object_Id__c, Asset_URL__c, Primary_Image_Small__c, Status, (SELECT Contact__c, Contact__r.Name, Customer__c, Customer__r.Name, CreatedDate FROM Consumer_Inquiries__r ORDER BY CreatedDate DESC LIMIT 1) FROM Asset WHERE AccountId = :accountId ORDER BY Name ASC LIMIT :lim OFFSET :offset';

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