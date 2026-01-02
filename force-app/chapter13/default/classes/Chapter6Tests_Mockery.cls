@IsTest
public with sharing class Chapter6Tests_Mockery {
    @IsTest
    static void controller_it_should_return_contacts() {
        //prepare
        Account testAccount = new Account(Name = 'Test Account', Id = Util_MockIdGenerator.getMockId(new Account()));

        List<Contact> contactsToReturn = new List<Contact>();
        for(Integer ii = 0; ii < 10; ii++) {
            Contact cont = new Contact();
            cont.FirstName = 'Test';
            cont.LastName = 'Contact '+ ii;
            cont.Id = Util_MockIdGenerator.getMockId(new Contact());
            cont.AccountId = testAccount.Id;
        }

        //arrange
        Mock contactSelectorMock = Mock.forType(ContactSelector.class);
        MethodSpy contactsPerAccountSpy = contactSelectorMock.spyOn('contactsPerAccount');
        ContactService myContactService = new ContactService();
        myContactService.contactSelect = (ContactSelector) contactSelectorMock.stub;
        contactsPerAccountSpy.returnsOnce(contactsToReturn);

        Mock utilQueryMock = Mock.forType(Util_Query.class);
        MethodSpy querySpy = utilQueryMock.spyOn('query');
        ContactSelector myContactSelector = new ContactSelector();
        querySpy.returnsOnce(contactsToReturn);

        //act
        List<Contact> myContacts = ViewContactController.returnContactsPerAccount(testAccount.Id);

        //assert
        for(Integer kk; kk < 10; kk++) {
            Contact currentTag = myContacts[kk];
            Assert.isTrue(currentTag.FirstName.equals('Test'), 'Contacts should have correct name.');
            Assert.isTrue(currentTag.LastName.contains(String.valueOf(kk)), 'Contacts should have correct name and be in order.');
        }
    }
    
    @IsTest
    static void service_it_should_return_contacts() {
        //prepare
        Account testAccount = new Account(Name = 'Test Account', Id = Util_MockIdGenerator.getMockId(new Account()));

        List<Contact> contactsToReturn = new List<Contact>();
        for(Integer ii = 0; ii < 10; ii++) {
            Contact cont = new Contact();
            cont.FirstName = 'Test';
            cont.LastName = 'Contact '+ ii;
            cont.Id = Util_MockIdGenerator.getMockId(new Contact());
            cont.AccountId = testAccount.Id;

            contactsToReturn.add(cont);
        }

        //arrange
        Mock contactSelectorMock = Mock.forType(ContactSelector.class);
        MethodSpy contactsPerAccountSpy = contactSelectorMock.spyOn('contactsPerAccount');
        ContactService myContactService = new ContactService();
        myContactService.contactSelect = (ContactSelector) contactSelectorMock.stub;
        contactsPerAccountSpy.returnsOnce(contactsToReturn);

        //act
        List<Contact> myContacts = myContactService.getContactsPerAccount(testAccount.Id);

        //assert
        for(Integer kk; kk < 10; kk++) {
            Contact currentTag = myContacts[kk];
            Assert.isTrue(currentTag.FirstName.equals('Test'), 'Contacts should have correct name.');
            Assert.isTrue(currentTag.LastName.contains(String.valueOf(kk)), 'Contacts should have correct name and be in order.');
        }
    }

    @IsTest
    static void selector_it_should_return_contacts() {
        //prepare
        Account testAccount = new Account(Name = 'Test Account', Id = Util_MockIdGenerator.getMockId(new Account()));

        List<Contact> contactsToReturn = new List<Contact>();
        for(Integer ii = 0; ii < 10; ii++) {
            Contact cont = new Contact();
            cont.FirstName = 'Test';
            cont.LastName = 'Contact '+ ii;
            cont.Id = Util_MockIdGenerator.getMockId(new Contact());
            cont.AccountId = testAccount.Id;

            contactsToReturn.add(cont);
        }

        //arrange
        Mock utilQueryMock = Mock.forType(Util_Query.class);
        MethodSpy querySpy = utilQueryMock.spyOn('query');
        ContactSelector myContactSelector = new ContactSelector();
        querySpy.returnsOnce(contactsToReturn);

        //act
        List<Contact> myContacts = myContactSelector.contactsPerAccount(testAccount.Id);

        //assert
        for(Integer kk; kk < 10; kk++) {
            Contact currentTag = myContacts[kk];
            Assert.isTrue(currentTag.FirstName.equals('Test'), 'Contacts should have correct name.');
            Assert.isTrue(currentTag.LastName.contains(String.valueOf(kk)), 'Contacts should have correct name and be in order.');
        }
    }
}