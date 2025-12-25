import { LightningElement, wire } from 'lwc';
import returnTopTenAccounts from '@salesforce/apex/TableController.returnTopTenAccounts';
import { COLUMNS_DEFINITION } from './datatableColumns.js';
import Utilities from 'c/notifUtils';
let utility;

export default class AccessibleDatatable extends LightningElement {
    columns = COLUMNS_DEFINITION;
    accounts;
    _wiredAccounts;
    error;

    constructor() {
        super();
        utility = new Utilities(this);
    }

    @wire(returnTopTenAccounts)
    wiredAccounts(result) {
        this._wiredAccounts = result;
        if (result.data) {
            this.accounts = result.data;
            this.error = undefined;
        } else if(result.error) {
            this.error = result.error;
            this.accounts = undefined;
            utility.showNotif('There has been an error loading accounts!', this.error, 'error');
        } else {
            this.error = undefined;
            this.accounts = undefined;
            utility.showNotif('Please complete Chapter 1 org setup!', 'You have no accounts with geolocations to query, which is why you are seeing this notification. Please review Chapter 1.', 'warning');
        }
    }
}