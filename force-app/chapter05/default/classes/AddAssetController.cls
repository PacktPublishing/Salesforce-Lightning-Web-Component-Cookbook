public with sharing class AddAssetController {
    public static final String REGEXP = '[^a-zA-Z]';
    public static final String REPLACE = '';


    @AuraEnabled(cacheable=true)
    public static String returnDepartmentsWrapper(){
        try {
            AssetRetrievalDatabase.DepartmentsWrapper retrievedDepartments = AssetRetrievalDatabase.getDepartments();

            return retrievedDepartments == null ? null : JSON.serialize(retrievedDepartments);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static String searchAssetWrappers(String search, Integer departmentId) {
        try {
            String searchTerm = search.replaceAll(REGEXP, REPLACE);
            List<ObjectWrappers.AssetWrapper> searchResults = AssetRetrievalDatabase.searchByTerm(String.escapeSingleQuotes(searchTerm), departmentId);

            return searchResults == null ? null : JSON.serialize(searchResults);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @auraEnabled
    public static Map<Integer, String> saveAssetWrappers(String jsonToParse, Id accountId) {
        try {
            List<ObjectWrappers.AssetWrapper> assetWrappers = (List<ObjectWrappers.AssetWrapper>) JSON.deserialize(jsonToParse, List<ObjectWrappers.AssetWrapper>.Class);
            Map<Integer, String> saveResults = AssetRetrievalDatabase.upsertAssets(assetWrappers, accountId);

            return saveResults == null ? null : saveResults;    
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}