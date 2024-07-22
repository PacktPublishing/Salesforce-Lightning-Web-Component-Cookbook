import { LightningElement, api, wire } from 'lwc';
import returnFiveContactsPerAccount from '@salesforce/apex/ViewContactController.returnFiveContactsPerAccount';
import Utilities from 'c/notifUtils';
let utility;

export default class ViewContactShell extends LightningElement {
    @api recordId;
    @api objectApiName
    contactsLoading = true;
    displayContacts;
    error;

    editingContact = false;

    connectedCallback() {
        utility = new Utilities(this);
    }

    @wire(returnFiveContactsPerAccount, { accountIdString: '$recordId' })
    wiredContacts({ error, data }) {
        if(data) {
            this.displayContacts = data;
            this.error = undefined
            this.contactsLoading = false;
        } else if(error) {
            this.displayContacts = undefined;
            this.error = error;
            utility.showNotif('There has been an error loading your contacts!', this.error, 'error');
        }
    }

    handleShowEdit(event) {
        this.editingContact = event.detail.value;
    }
}