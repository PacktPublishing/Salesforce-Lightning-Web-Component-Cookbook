public with sharing class CaptureAccountGeolocationController {
    @TestVisible private static CaptureAccountGeolocationService service = new CaptureAccountGeolocationService();

    @AuraEnabled
    public static void updateGeolocation(String accountId, Decimal lat, Decimal lng){
        try {
            service.prepareAccountToUpdate(Id.valueOf(accountId), lat, lng);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}