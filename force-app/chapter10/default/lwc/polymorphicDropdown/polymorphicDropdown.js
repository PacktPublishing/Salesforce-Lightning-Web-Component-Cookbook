import { LightningElement, api } from 'lwc';

export default class SearchableDropdown extends LightningElement {
    @api dropdownOptions;

    selectOption(event) {
        let selectedOption = event.currentTarget.dataset.id;

        let tempOptions = this.dropdownOptions;

        let selectedElement = tempOptions.filter(option => option.value === selectedOption);

        const setSelectionEvent = new CustomEvent('setselection', {
            bubbles : false,
            composed : false,
            detail: {
                selectedElement : selectedElement
            }
        });

        this.dispatchEvent(setSelectionEvent);
    }
}