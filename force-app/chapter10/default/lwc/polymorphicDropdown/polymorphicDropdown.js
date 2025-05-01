import { LightningElement, api } from 'lwc';

export default class SearchableDropdown extends LightningElement {
    @api dropdownPlaceholder;
    @api dropdownOptions;

    selectedOption;

    selectOption(event) {
        this.selectedOption = event.currentTarget.dataset.id;
        let tempOptions = this.dropdownOptions;

        let selectedElement = tempOptions.filter(option => option.label === this.selectedOption);

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