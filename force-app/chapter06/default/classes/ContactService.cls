public with sharing class ContactService {
    @TestVisible private ContactSelector contactSelect = new ContactSelector();

    public List<Contact> getContactsPerAccount(Id accountId) {
        return this.contactSelect.contactsPerAccount(accountId);
    }
}