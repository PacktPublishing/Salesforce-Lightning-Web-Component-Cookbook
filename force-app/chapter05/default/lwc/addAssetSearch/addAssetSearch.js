import { LightningElement, api } from 'lwc';

export default class AddAssetSearch extends LightningElement {
    termToSearch;

    @api get searchTerm() {
        return this.termToSearch;
    }

    handleChange(event) {
        this.termToSearch = event.detail.value;
    }
}