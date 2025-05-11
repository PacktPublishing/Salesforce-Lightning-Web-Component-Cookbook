public with sharing class RecentConsumerController {
    @TestVisible private static RecentConsumerService service = new RecentConsumerService();

    @AuraEnabled(cacheable=true)
    public static List<RecentConsumerService.ConsumerWrapper> returnSearchedConsumerWrappers(String searchTerm){
        try {
            return service.wrapSearchedConsumers(String.escapeSingleQuotes(searchTerm));            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}