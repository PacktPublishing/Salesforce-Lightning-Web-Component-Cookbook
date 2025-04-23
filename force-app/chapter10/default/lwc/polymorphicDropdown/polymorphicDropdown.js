import { LightningElement, api } from 'lwc';

export default class SearchableDropdown extends LightningElement {
    @api dropdownLabel;
    @api dropdownPlaceholder;
    @api dropdownOptions;

    selectedOption;

    selectOption(event) {
        this.selectedOption = event.currentTarget.dataset.id;

        console.log(JSON.stringify(this.selectedOption));
        console.log(JSON.stringify(this.dropdownOptions));

        let selectedElement = this.dropdownOptions.filter(option => option.label === this.selectedOption);

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