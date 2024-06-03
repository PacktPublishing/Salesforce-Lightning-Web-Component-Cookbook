public with sharing class TransferAssetAccess {
    
    public static List<LocaleWrapper> getComboboxCountries() {
        List<LocaleWrapper> countries = new List<LocaleWrapper>();

        for(AggregateResult ar : TransferAssetDatabase.getCountries()) {
            countries.add(new LocaleWrapper(String.valueOf(ar.get('BillingCountry'))));
        }

        return countries;
    }
    
    public static List<LocaleWrapper> getComboboxCities(String countryName) {
        List<LocaleWrapper> cities = new List<LocaleWrapper>();

        for(AggregateResult ar : TransferAssetDatabase.getCities(countryName)) {
            cities.add(new LocaleWrapper(String.valueOf(ar.get('BillingCity'))));
        }

        return cities;
    }

    public static List<AccountWrapper> getAccountWrappers(String selectedCity) {
        List<AccountWrapper> accountWrappers = new List<AccountWrapper>();

        for(Account acc : TransferAssetDatabase.getAccountsByCity(selectedCity)) {
            AccountWrapper wrap = new AccountWrapper(acc);

            accountWrappers.add(wrap);
        }

        return accountWrappers;
    }

    public static void transferAssetWrapper(AssetWrapper wrap) {
        Asset ast = new Asset(Id = wrap.assetId, AccountId = wrap.accountId);
        
        TransferAssetDatabase.updateAsset(ast);
    }

    public class LocaleWrapper {
        @AuraEnabled public String label;
        @AuraEnabled public String value;

        public LocaleWrapper(String locale) {
            this.label = locale == null ? 'No Locale Specified' : locale;
            this.value = locale;
        }
    }

    public class AccountWrapper {
        @AuraEnabled public String accountId;
        @AuraEnabled public String accountName;
        @AuraEnabled public String accountCity;
        @AuraEnabled public String accountState;

        public AccountWrapper(Account acc) {
            this.accountId = acc.Id;
            this.accountName = acc.Name;
            this.accountCity = acc.BillingCity;
            this.accountState = acc.BillingState;
        }
    }

    public class assetWrapper {
        public String assetId;
        public String accountId;
    }
}