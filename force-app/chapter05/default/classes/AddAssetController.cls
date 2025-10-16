public with sharing class AddAssetController {
    @TestVisible private static AddAssetService addAssetService = new AddAssetService();
    @TestVisible private static final String REGEXP = '[^a-zA-Z]';
    @TestVisible private static final String REPLACE = '';

    @AuraEnabled(cacheable=true)
    public static String returnDepartmentsWrapper(){
        try {
            AddAssetService.DepartmentsWrapper retrievedDepartments = addAssetService.getDepartmentWrappers();

            return retrievedDepartments == null ? null : JSON.serialize(retrievedDepartments);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static String searchAssetWrappers(String search, Integer departmentId) {
        try {
            String searchTerm = search.replaceAll(REGEXP, REPLACE);
            List<ObjectWrappers.AssetWrapper> searchResults = addAssetService.getSearchedAssets(searchTerm, departmentId);

            return searchResults == null ? null : JSON.serialize(searchResults);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @auraEnabled
    public static Map<Integer, String> saveAssetWrappers(String jsonToParse, Id accountId) {
        try {
            List<ObjectWrappers.AssetWrapper> assetWrappers = (List<ObjectWrappers.AssetWrapper>) JSON.deserialize(jsonToParse, List<ObjectWrappers.AssetWrapper>.Class);
            Map<Integer, String> saveResults = addAssetService.upsertAssetsAndReturnInfoMap(assetWrappers, accountId);

            return saveResults == null ? null : saveResults;    
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}