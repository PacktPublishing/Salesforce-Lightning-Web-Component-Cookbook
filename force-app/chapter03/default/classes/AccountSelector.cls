public inherited sharing class AccountSelector {

    Util_Query queryUtil = new Util_Query();
    private static final String TOP_TEN_ACCOUNTS_QUERY = 'SELECT Id, Name, Phone, BillingCity, BillingState, BillingCountry, Museum_Office__latitude__s, Museum_Office__longitude__s, AnnualRevenue FROM Account WHERE Museum_Office__latitude__s != null ORDER BY AnnualRevenue DESC NULLS LAST LIMIT 10';

    public List<AccountWrapper> topTenAccountsByRevenue() {
        List<Account> queryResult = (List<Account>) queryUtil.query(TOP_TEN_ACCOUNTS_QUERY);

        if(queryResult.size() == 0) {
            return null;
        }

        List<AccountWrapper> queriedWrappers = new List<AccountWrapper>();

        for(Account acct : queryResult) {
            queriedWrappers.add(new AccountWrapper(acct));
        }

        return queriedWrappers;
    }

    public class AccountWrapper {
        @AuraEnabled public String Id;
        @AuraEnabled public String Name;
        @AuraEnabled public String Phone;
        @AuraEnabled public String BillingCity;
        @AuraEnabled public String BillingState;
        @AuraEnabled public String BillingCountry;
        @AuraEnabled public Decimal AnnualRevenue;
        @AuraEnabled public List<LocationWrapper> markers;

        public AccountWrapper(Account acct) {
            this.Id = acct.Id;
            this.Name = acct.Name;
            this.Phone = acct.Phone;
            this.BillingCity = acct.BillingCity;
            this.BillingState = acct.BillingState;
            this.BillingCountry = acct.BillingCountry;
            this.AnnualRevenue = acct.AnnualRevenue;

            this.markers = new List<LocationWrapper>();

            MarkerWrapper marker = new MarkerWrapper();
            marker.Latitude = String.valueOf(acct.Museum_Office__Latitude__s);
            marker.Longitude = String.valueOf(acct.Museum_Office__Longitude__s);

            LocationWrapper location = new LocationWrapper();
            location.location = marker;
            location.title = acct.Name;
            location.value = acct.Id;

            this.markers.add(location);
        }
    }

    public class LocationWrapper {
        @AuraEnabled public MarkerWrapper location;
        @AuraEnabled public String value;
        @AuraEnabled public String title;
    }

    public class MarkerWrapper {
        @AuraEnabled public String Latitude;
        @AuraEnabled public String Longitude;
    }
}