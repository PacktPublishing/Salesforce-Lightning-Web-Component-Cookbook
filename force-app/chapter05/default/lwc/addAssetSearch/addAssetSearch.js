import { LightningElement, api } from 'lwc';

export default class AddAssetSearch extends LightningElement {
    @api searchTerm;    

    handleChange(event) {
        this.searchTerm = event.detail.value;
    }
}