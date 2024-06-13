import { LightningElement, api, wire } from 'lwc';
import returnAccountWrapperList from '@salesforce/apex/AccountService.returnAccountWrapperList';
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class TopTenAccountTabset extends LightningElement {
    accounts;
    _wiredAccounts;

    @wire(returnAccountWrapperList)
    wiredAccounts(result) {
        this._wiredAccounts = result;
        if (result.data) {
            this.accounts = JSON.parse(result.data);
            this.error = undefined;
        } else if(result.error) {
            this.error = result.error;
            this.accounts = undefined;
            this.showNotif('There has been an error!', this.error, 'error');
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