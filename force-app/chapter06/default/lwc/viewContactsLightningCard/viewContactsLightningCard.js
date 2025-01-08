import { LightningElement, api } from 'lwc';

export default class ViewContactsLightningCard extends LightningElement {
    @api contactsToView;
    contactIsSelected = false;

    handleSelectContact(event) {
        let contactId = event.detail.selectedContact;
        this.contactIsSelected = true;

        const setContactEvent = new CustomEvent('setcontact', {
            bubbles : false,
            composed : false,
            detail: {
                setContactTo : contactId
            }
        });

        this.dispatchEvent(setContactEvent);
    }
}