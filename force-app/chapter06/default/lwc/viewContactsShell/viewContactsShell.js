import { LightningElement, api, wire } from 'lwc';
import returnContactsPerAccount from '@salesforce/apex/ViewContactController.returnContactsPerAccount';
import Utilities from 'c/notifUtils';
let utility;

export default class ViewEditContactsFlattened extends LightningElement {
    @api accountId;
    contactsToView;
    _wiredContacts;
    selectedContact = '';
    addEventInactive = true;

    connectedCallback() {
        utility = new Utilities(this);
    }

    @wire(returnContactsPerAccount, {accountIdString : '$accountId'})
    wiredContacts(result) {
        this._wiredContacts = result;
        if (result.data) {
            this.contactsToView = result.data;
        } else if(result.error) {
            this.contactsToView = undefined;
            utility.showNotif('There has been an error returning contacts!', result.error, 'error');
        }
    }

    triggerFlow(event) {
        this.addEventInactive = event.target.addEventInactive;
    }

    setContactToSelected(event) {
        this.selectedContact = event.detail.setContactTo;
    }

    resetShell(event) {
        this.addEventInactive = event.detail.addEventInactive;
        utility.showNotif('Your event has been inserted successfully!', event.detail.outputVariables[0].value, 'success');
    }
}