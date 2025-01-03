import { LightningElement } from 'lwc';

export default class ViewContactsAddEventButton extends LightningElement {
    handleAddEvent() {
        let updateAddEventInactive = false;

        const addEventEvent = new CustomEvent('addevent', {
            bubbles : true,
            composed : true,
            target: {
                addEventInactive : updateAddEventInactive
            }
        });

        this.dispatchEvent(addEventEvent);
    }
}