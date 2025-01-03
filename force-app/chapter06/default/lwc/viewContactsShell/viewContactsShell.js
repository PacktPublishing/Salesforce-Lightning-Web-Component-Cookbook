import { LightningElement, api, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import returnContactsPerAccount from '@salesforce/apex/ViewContactController.returnContactsPerAccount';
import Utilities from 'c/notifUtils';
let utility;

export default class ViewEditContactsFlattened extends NavigationMixin(LightningElement) {
    @api recordId;
    contactsToView;
    _wiredContacts;

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