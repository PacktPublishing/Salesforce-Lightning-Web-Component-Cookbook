public with sharing class TransferAssetPresentation {
    @AuraEnabled(cacheable=true)
    public static String returnCountries(){
        try {
            return JSON.serialize(TransferAssetBusinessLogic.getComboboxCountries());
        } catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String returnCities(String countryName){
        try {
            return JSON.serialize(TransferAssetBusinessLogic.getComboboxCities(countryName));
        } catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String returnAccounts(String cityName){
        try {
            return JSON.serialize(TransferAssetBusinessLogic.getAccountWrappers(cityName));
        } catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void setAssetWrapper(String assetId, String accountId){
        try {
            TransferAssetBusinessLogic.transferAssetWrapper(new TransferAssetBusinessLogic.AssetWrapper(assetId, accountId));
        } catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}