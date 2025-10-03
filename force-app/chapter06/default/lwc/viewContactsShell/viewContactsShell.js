import { LightningElement, api, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import returnContactsPerAccount from '@salesforce/apex/ViewContactController.returnContactsPerAccount';
import Utilities from 'c/notifUtils';
let utility;
9
export default class ViewContactsShell extends NavigationMixin(LightningElement) {
    @api recordId;
    contactsToView;
    _wiredContacts;
    selectedContact = '';
    addEventInactive = true;

    connectedCallback() {
        utility = new Utilities(this);
    }

    @wire(returnContactsPerAccount, {accountIdString : '$recordId'})
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
        this.addEventInactive = event.detail.addEventInactive;
    }

    setContactToSelected(event) {
        this.selectedContact = event.detail.setContactTo;
    }

    resetShell(event) {
        this.addEventInactive = event.detail.addEventInactive;

        this.refreshPage();

        utility.showNotif('Your event has been inserted successfully!', event.detail.outputVariables, 'success');
    }

    refreshPage() {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.recordId,
                objectApiName: 'Account',
                actionName: 'view'
            }
        });
    }
}