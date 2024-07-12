public without sharing class TransferAssetAccess {
    
    public static List<AggregateResult> getCountries() {
        return [SELECT COUNT(Id), BillingCountry FROM Account GROUP BY BillingCountry ORDER BY BillingCountry NULLS FIRST];
    }

    public static List<AggregateResult> getCities(String selectedCountry) {
        return [SELECT COUNT(Id), BillingCity FROM Account WHERE BillingCountry = :selectedCountry GROUP BY BillingCity ORDER BY BillingCity NULLS FIRST];
    }
    
    public static List<Account> getAccountsByCity(String selectedCity) {
        return [SELECT Id, Name, BillingCity, BillingState FROM Account WHERE BillingCity = :selectedCity];
    }

    public static void updateAsset(Asset ast) {
        update ast;
    }
}