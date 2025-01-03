import { LightningElement } from 'lwc';

export default class ViewContactsAddEventButton extends LightningElement {
    addEventInactive = true;
    
    handleAddEvent() {
        this.addEventInactive = false;
    }
}