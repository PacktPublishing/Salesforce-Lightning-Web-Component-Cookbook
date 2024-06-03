/* eslint-disable @lwc/lwc/no-async-await */
import { LightningElement, api, wire } from 'lwc';
import returnCountries from '@salesforce/apex/TransferAssetInterface.returnCountries';
import returnCities from '@salesforce/apex/TransferAssetInterface.returnCities';
import returnAccountWrappers from '@salesforce/apex/TransferAssetInterface.returnAccountWrappers';
import setAssetWrapper from '@salesforce/apex/TransferAssetInterface.setAssetWrapper';
import { RefreshEvent } from 'lightning/refresh';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const columns = [
    { label: 'Account', fieldName: 'accountName' },
    { label: 'City', fieldName: 'accountCity' },
    { label: 'State', fieldName: 'accountState' }
];

export default class TransferAsset extends LightningElement {
    @api recordId;
    error;
    countryOptions;
    countryValue;
    cityOptions;
    cityValue;
    accountData;
    accountValue;
    columns = columns;
    transferDisabled = true;

    
    @wire(returnCountries)
    wiredCountries({error, data}) {
        if (data) {
            this.countryOptions = JSON.parse(data);
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.countryOptions = undefined;
            this.showNotif('There has been an error!', error.message, 'error');
        }
    }

    refreshForm() {
        this.countryValue = undefined;
        this.cityOptions = undefined;
        this.accountData = undefined;
        this.citiesAreLoaded = false;
        this.dispatchEvent(new RefreshEvent());
    }

    handleCountryChange(event) {
        this.countryValue = event.target.value;
        this.cityOptions = undefined;
        this.accountData = undefined;
        this.getCities(this.countryValue);
    }

    handleCityChange(event) {
        this.cityValue = event.target.value;
        this.getAccounts(this.cityValue);
    }
    
    async getCities(countryValue) {
        try {
            const cities = await returnCities({countryName : countryValue});
            this.cityOptions = JSON.parse(cities);
            this.error = undefined;
        } catch (error) {
            this.error = error;
            this.cityOptions = undefined;
            this.showNotif('There has been an error!', error.message, 'error');
        }
    }

    async getAccounts(cityValue) {
        try {
            const accounts = await returnAccountWrappers({cityName : cityValue});
            this.accountData = JSON.parse(accounts);
            this.error = undefined;
        } catch(error) {
            this.accountData = undefined;
            this.error = error;
            this.showNotif('There has been an error!', error.message, 'error');
        }
    }

    setAccountId(event) {
        this.accountValue = event.detail.selectedRows[0].accountId;
        this.transferDisabled = false;
    }

    async transferAsset() {
        try {
            await setAssetWrapper({assetId : this.recordId, accountId : this.accountValue});
            this.refreshForm();
        } catch(error) {
            this.error = error;
            this.showNotif('There has been an error!', error.message, 'error');
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