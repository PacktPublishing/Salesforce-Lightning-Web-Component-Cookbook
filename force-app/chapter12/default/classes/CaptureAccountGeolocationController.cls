public with sharing class CaptureAccountGeolocationController {
    @TestVisible private static CaptureAccountGeolocationService service = new CaptureAccountGeolocationService();

    @AuraEnabled
    public static void updateGeolocation(String accountId, String lat, String lng){
        try {
            service.prepareAccountToUpdate(Id.valueOf(accountId), Decimal.valueOf(lat), Decimal.valueOf(lng));
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}