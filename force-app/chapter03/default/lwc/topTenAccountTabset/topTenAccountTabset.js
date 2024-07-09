import { LightningElement, wire } from 'lwc';
import returnAccountWrapperList from '@salesforce/apex/AccountService.returnAccountWrapperList';
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class TopTenAccountTabset extends LightningElement {
    accounts;
    error;

    @wire(returnAccountWrapperList)
    wiredAccounts({error, data}) {
        if(data) {
            this.accounts = JSON.parse(data);
            this.error = undefined;
        } else if(error) {
            this.error = error;
            this.accounts = undefined;
            this.showNotif('There has been an error!', this.error, 'error');
        } else {
            this.error = undefined;
            this.accounts = undefined;
            this.showNotif('Please complete Chapter 1 org setup!', 'You have no accounts with geolocations to query, which is why you are seeing this notification. Please review Chapter 1.', 'warning');
        }
    }

    showNotif(title, msg, variant) {
        const evt = new ShowToastEvent({
          title: title,
          message: msg,
          variant: variant,
        });
        this.dispatchEvent(evt);
    }
}