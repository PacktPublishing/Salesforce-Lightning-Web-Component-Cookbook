import { LightningElement, api } from 'lwc';

export default class SearchableDropdownAccessible extends LightningElement {
    @api dropdownOptions;

    selectedOption;

    selectOption(event) {
        this.selectedOption = event.currentTarget.dataset.id;

        let tempOptions = this.dropdownOptions;

        let selectedElement = tempOptions.filter(option => option.value === this.selectedOption);

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