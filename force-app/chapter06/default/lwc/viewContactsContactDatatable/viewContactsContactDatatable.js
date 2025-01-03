import { LightningElement, api } from 'lwc';

export default class ViewContactsContactDatatable extends LightningElement {
    contactColumnsDatatable = [
        { label: 'First Name', fieldName: 'FirstName' },
        { label: 'Last Name', fieldName: 'LastName' },
        { label: 'Title', fieldName: 'Title' },
        { label: 'Email', fieldName: 'Email' },
        { label: 'Phone', fieldName: 'Phone' }
    ];

    @api contactsToView;

    handleContactSelect(event) {
        let updatedSelectedContact = event.detail.selectedRows[0].Id;

        const selectContactEvent = new CustomEvent('selectcontact', {
            bubbles : true,
            composed : false,
            detail: {
                selectedContact : updatedSelectedContact
            }
        });

        this.dispatchEvent(selectContactEvent);
    }
}