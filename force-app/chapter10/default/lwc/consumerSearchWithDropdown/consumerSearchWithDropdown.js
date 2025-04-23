import { LightningElement } from 'lwc';
import returnSearchedConsumerWrappers from '@salesforce/apex/RecentConsumerController.returnSearchedConsumerWrappers';

export default class ConsumerSearchWithDropdown extends LightningElement {
    searchResults;
    debounceTimeout;

    selectedOption;
    displayedOption;

    sendSearch(event) {
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
                    console.log(error);
                }
            }, 1000);
        } else {
            this.searchResults = null;
        }
    }

    async search(searchTerm) {
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
    }

    handleSelection(event) {
        this.selectedOption = event.detail.selectedElement[0];
        this.displayedOption = this.selectedOption.label;
        this.searchResults = null;
    }
}