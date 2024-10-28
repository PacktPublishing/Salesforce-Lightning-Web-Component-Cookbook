import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { loadStyle } from 'lightning/platformResourceLoader';
import customCSS from '@salesforce/resourceUrl/toastCSS';

let mainObject;

export default class NotifUtils {
    isCSSLoaded = false;

    constructor(superMain) {
        mainObject = superMain;
        loadStyle(mainObject, customCSS);
    }

    showNotif(title, msg, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: msg,
            variant: variant
        });
        mainObject.dispatchEvent(evt);
    }
}