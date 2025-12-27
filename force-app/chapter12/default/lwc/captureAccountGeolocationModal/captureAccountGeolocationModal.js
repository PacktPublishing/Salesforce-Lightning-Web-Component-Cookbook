import { api } from 'lwc';
import LightningModal from 'lightning/modal';
import updateGeolocation from '@salesforce/apex/CaptureAccountGeolocationController.updateGeolocation';
import Utilities from 'c/notifUtils';
let utility;

export default class CaptureAccountGeolocationLWC extends LightningModal {
    @api content;
    recordId;
    latitude;
    longitude;

    connectedCallback() {
        utility = new Utilities(this);

        this.recordId = this.content.recordId;

        this.findGeolocation();
    }

    findGeolocation() {
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(
                (position) => {
                    this.latitude = parseFloat(position.coords.latitude);
                    this.longitude = parseFloat(position.coords.longitude);
                },
                (error) => {
                    utility.showNotif('There has been an error capturing geolocation!', error.message, 'error');

                    this.close();
                }
            );
        }
        else {
            utility.showNotif('There has been an error loading geolocation!', 'Ensure that you have enabled location.', 'error');

            this.close();
        }
    }

    async captureGeolocation(event) {
        try{
            await updateGeolocation({accountId: this.recordId, lat: this.lat, lng: this.lng});
            
            utility.showNotif('Geolocation has been saved!', 'Success!', 'success');

            const successEvent = new CustomEvent('savesuccess', {
                bubbles: false,
                composed: false,
                detail: event.detail.id
            });

            this.dispatchEvent(successEvent);

            this.close();
        } catch(error) {
            utility.showNotif('There has been an error capturing geolocation!', error.message, 'error');
        }
    }
}