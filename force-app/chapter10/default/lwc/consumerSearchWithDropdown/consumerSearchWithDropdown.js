import { LightningElement, api } from 'lwc';
import returnSearchedConsumerWrappers from '@salesforce/apex/RecentConsumerController.returnSearchedConsumerWrappers';
import Utilities from 'c/notifUtils';
let utility;

export default class ConsumerSearchWithDropdown extends LightningElement {
    _value;
    
    @api
    get value() {
        return this._value;
    } set value(val) {
        this._value = val;
    }

    searchResults;

    debounceTimeout;

    selectedOption;
    displayedOption;

    connectedCallback() {
        utility = new Utilities(this);
    }

    @api
    showHelpMessageIfInvalid() {
        let component = this.template.querySelector('[data-inputable="true"]');
        component.showHelpMessageIfInvalid();
    }

    @api
    get validity() {
        let component = this.template.querySelector('[data-inputable="true"]');
        return component.validity;
    }

    async sendSearch(event) {
        try {
            let searchTerm = event.detail.value;

            if(searchTerm.length > 2) {
                if(this.debounceTimeout) {
                    clearTimeout(this.debounceTimeout);
                }
                // eslint-disable-next-line @lwc/lwc/no-async-operation
                this.debounceTimeout = setTimeout(() => {
                    try {
                        this.search(searchTerm);
                    } catch(error) {
                        utility.showNotif('There has been an error returning consumers!', error, 'error');
                    }
                }, 300);
            } else {
                this.searchResults = undefined;
            }
        } catch(error) {
            utility.showNotif('There has been an error searching!', error.message, 'error');
        }
    }

    async search(searchTerm) {
        try{
            const searchedConsumers = await returnSearchedConsumerWrappers({searchTerm : searchTerm});

            let tempConsumers = JSON.parse(JSON.stringify(searchedConsumers));
            let results = [];

            tempConsumers.forEach(consumer => {
                if(consumer.type === 'Contact') {
                    consumer.icon = 'utility:contact';
                    consumer.altText = 'Contact';
                } else if (consumer.type === 'Customer') {
                    consumer.icon = 'utility:customer';
                    consumer.altText = 'Customer';
                    consumer.fact = new Intl.NumberFormat("en-US", {style: "currency", currency: 'USD'}).format(consumer.fact);
                }

                results.push(consumer);    
            })

            if(results.length > 0) {
                this.searchResults = results.sort((a, b) => {
                    return (a.label > b.label) ? 1 : -1;
                });    
            }
        } catch(error) {
            utility.showNotif('There has been an error loading consumers!', error, 'error');
        }
    }

    handleSelection(event) {
        this.selectedOption = event.detail.selectedElement[0];
        this.displayedOption = this.selectedOption.label;
        this.searchResults = undefined;

        const setSearchSelectionEvent = new CustomEvent('setsearchvalue', {
            bubbles : true,
            composed : true,
            detail: {
                selectedElement : this.selectedOption
            }
        });

        this.dispatchEvent(setSearchSelectionEvent);
    }
}