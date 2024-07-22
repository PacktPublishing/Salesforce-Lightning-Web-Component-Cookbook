public with sharing class ContactService {
    ContactSelector selector = new ContactSelector();

    public List<Contact> getFiveContactsPerAccount(Id accountId) {
        return this.selector.fiveContactsPerAccount(accountId);
    }
}