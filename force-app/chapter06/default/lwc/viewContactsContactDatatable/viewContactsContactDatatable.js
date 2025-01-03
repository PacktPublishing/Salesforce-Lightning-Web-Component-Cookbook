import { LightningElement } from 'lwc';

export default class ViewContactsContactDatatable extends LightningElement {
    contactColumnsDatatable = [
        { label: 'First Name', fieldName: 'FirstName' },
        { label: 'Last Name', fieldName: 'LastName' },
        { label: 'Title', fieldName: 'Title' }
    ];

    selectedContact = '';

    handleContactSelect(event) {
        this.selectedContact = event.detail.selectedRows[0].Id;
    }
}