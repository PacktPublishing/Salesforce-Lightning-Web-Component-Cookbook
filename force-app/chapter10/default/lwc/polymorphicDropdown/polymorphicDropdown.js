import { LightningElement, api } from 'lwc';

export default class SearchableDropdown extends LightningElement {
    @api dropdownPlaceholder;
    @api dropdownOptions;

    selectedOption;

    selectOption(event) {
        this.selectedOption = event.currentTarget.dataset.id;

        console.log(JSON.stringify(event.currentTarget.dataset));
        let tempOptions = this.dropdownOptions;

        let selectedElement = tempOptions.filter(option => option.value === this.selectedOption);

        console.log('selected element polymorphic.js: ' + JSON.stringify(selectedElement));

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