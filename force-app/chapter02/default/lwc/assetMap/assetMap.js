import { LightningElement, api, wire } from 'lwc';
import getMapMarkers from '@salesforce/apex/AssetMapPresentation.getMapMarkers';
import{ refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class AssetMap extends LightningElement {
    @api recordId;
    _wiredMarkers;
    mapMarkers;

    @wire(getMapMarkers, {assetId : '$recordId'})
    wiredMapMarkers(result) {
        this._wiredMarkers = result;
        if (result.data) {
            this.mapMarkers = JSON.parse(result.data);
            this.error = undefined;
        } else if(result.error) {
            this.error = result.error;
            this.mapMarkers = undefined;
            this.showNotif('There has been an error!', this.error, 'error');
        }
    }

    refreshMap() {
        return refreshApex(this._wiredMarkers);
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