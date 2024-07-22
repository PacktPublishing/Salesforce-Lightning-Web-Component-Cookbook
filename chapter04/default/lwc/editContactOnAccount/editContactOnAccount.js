import { LightningElement, api, track } from 'lwc';
import Contact from '@salesforce/schema/Contact';
import SALUTATION from '@salesforce/schema/Contact.Salutation';
import FIRST_NAME from '@salesforce/schema/Contact.FirstName';
import LAST_NAME from '@salesforce/schema/Contact.LastName';
import TITLE from '@salesforce/schema/Contact.Title';
import PHONE from '@salesforce/schema/Contact.Phone';
import Utilities from 'c/notifUtils';
let utility;

export default class EditContactOnAccount extends LightningElement {
    @api recordId;
    @api displayContacts;
    @api objectApiName

    contactObject = Contact;
    salutationField = SALUTATION;
    firstNameField = FIRST_NAME;
    lastNameField = LAST_NAME;
    titleField = TITLE;
    phoneField = PHONE;

    @track contactsToEdit = [];
    contactsLoaded = false;

    connectedCallback() {
        utility = new Utilities(this);

        this.contactsToEdit = this.displayContacts.map(contact => ({...contact, 'isSaved' : false}));
        this.contactsLoaded = true;
    }

    handleSave(event) {
        let contactId = new String(event.detail.id);
        
        try{
            let contactIndex = this.contactsToEdit.findIndex((contact) => contact.Id == contactId);
            this.contactsToEdit[contactIndex].isSaved = true;

            let inputFields = this.template.querySelectorAll('lightning-input-field[data-id="' + contactId + '"]');
            inputFields.forEach((field) => {field.disabled = true;});
        } catch(e) {
            utility.showNotif('There has been an error saving your contacts!', e, 'error');
        }
    }

    handleDone() {
        const showedit = new CustomEvent('showedit', {
            detail: {value : false}
        });

        this.dispatchEvent(showedit);
    }
}