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

        if (navigator.geolocation) {    
            // Get the current position
            navigator.geolocation.getCurrentPosition(
                (position) => {
                    this.latitude = position.coords.latitude;
                    this.longitude = position.coords.longitude;
                },
                (error) => {
                    utility.showNotif('There has been an error capturing geolocation!', error.message, 'error');
                }
            );
        }
        else {
            utility.showNotif('There has been an error loading geolocation!', 'Ensure that you have enabled location.', 'error');
        }
    }

    async captureGeolocation(event) {
        try{
            await updateGeolocation({accountId: this.recordId, lat: this.lat, lng: this.lng});
            
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