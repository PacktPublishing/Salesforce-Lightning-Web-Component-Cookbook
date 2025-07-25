public with sharing class ContactService {
    @TestVisible private ContactSelector selector = new ContactSelector();

    public List<Contact> getContactsPerAccount(Id accountId) {
        return this.selector.contactsPerAccount(accountId);
    }
}