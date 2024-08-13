import { LightningElement, api, wire } from 'lwc';


export default class ViewContactOnAccount extends LightningElement {
    @api recordId;
    @api displayContacts;

    handleEdit() {
        const showedit = new CustomEvent('showedit', {
            detail: {value : true}
        });

        this.dispatchEvent(showedit);
    }
}