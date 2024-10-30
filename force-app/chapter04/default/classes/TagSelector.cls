public with sharing class TagSelector extends Util_Query {
    private static final String TAGS_WITH_ASSETS_BY_ACCOUNT_QUERY = 'SELECT Id, Name, (SELECT Id, Name, Department__c, Description, Is_Public_Domain__c, Object_Id__c, Primary_Image__c FROM Assets__r WHERE AccountId = :accountId) FROM Tag__c';

    public List<Tag__c> tagsWithAssetsByAccount(Id accountId) {
        Map<String, Object> bindMap = new Map<String, Object>{
            'accountId' => accountId
        };

        List<Tag__c> queryResult = (List<Tag__c>) queryWithBinds(TAGS_WITH_ASSETS_BY_ACCOUNT_QUERY, bindMap, AccessLevel.SYSTEM_MODE);
        
        return queryResult;
    }
}