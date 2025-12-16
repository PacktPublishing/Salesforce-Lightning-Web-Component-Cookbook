import { LightningElement, api, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import returnContactsPerAccount from '@salesforce/apex/ViewContactController.returnContactsPerAccount';
import Utilities from 'c/notifUtils';
let utility;

export default class FlattenedViewContacts extends NavigationMixin(LightningElement) {
    contactColumnsDatatable = [
        { label: 'First Name', fieldName: 'FirstName' },
        { label: 'Last Name', fieldName: 'LastName' },
        { label: 'Title', fieldName: 'Title' }
    ];

    @api recordId;
    contactsToView;
    _wiredContacts;
    selectedContact = '';
    addEventInactive = true;

    get flowInputVariables() {
        return [
            {
                name: 'AccountId',
                type: 'String',
                value: this.recordId
            },
            {
                name: 'ContactId',
                type: 'String',
                value: this.selectedContact
            }
        ];
    }

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

    handleContactSelect(event) {
        this.selectedContact = event.detail.selectedRows[0].Id;
    }

    handleAddEvent() {
        this.addEventInactive = false;
    }

    handleFlowStatusChange(event) {
        if (event.detail.status === 'FINISHED') {
            this.selectedContact = '';
            this.addEventInactive = true;

            this.refreshPage();

            utility.showNotif('Your event has been inserted successfully!', event.detail.outputVariables[0].value, 'success');
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