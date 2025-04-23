public with sharing class RecentConsumerService {
    @TestVisible private ContactSelector conSelect = new ContactSelector();
    @TestVisible private CustomerSelector cusSelect = new CustomerSelector();

    public List<ConsumerWrapper> wrapSearchedConsumers(String searchTerm) {
        List<ConsumerWrapper> consumerWrappers = new List<ConsumerWrapper>();
        
        List<sObject> sObjectsToWrap = new List<sObject>();
        List<sObject> contactsToWrap = (List<sObject>) conSelect.searchContacts(searchTerm);
        List<sObject> customersToWrap = (List<sObject>) cusSelect.searchCustomers(searchTerm);

        sObjectsToWrap.addAll(contactsToWrap);
        sObjectsToWrap.addAll(customersToWrap);

        for(sObject sObj : sObjectsToWrap) {
            consumerWrappers.add(new ConsumerWrapper(sObj));
        }

        return consumerWrappers;
    }

    public class ConsumerWrapper {
        @AuraEnabled public String label;
        @AuraEnabled public String value;
        @AuraEnabled public String type;
        @AuraEnabled public String fact;
        public String assetId;

        public ConsumerWrapper(sObject sObj) {
            this.label = (String) sObj.get('Name');
            this.value = sObj.Id;
            this.type = String.valueOf(sObj.getSObjectType());
            this.fact = (String) (this.type == 'Contact' ? sObj.getSObject('Account').get('Name') : String.valueOf(sObj.get('TotalLifeTimeValue')));
        }
    }
}