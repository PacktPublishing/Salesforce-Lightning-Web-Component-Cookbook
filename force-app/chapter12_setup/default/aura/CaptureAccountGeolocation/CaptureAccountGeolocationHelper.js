({
	findGeolocation : function(component, event) {
		//finds the geolocation of the user's device
		//prompts user to allow location access if not already allowed
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(
                (position) => {
                    component.set('v.latitude', position.coords.latitude);
                    component.set('v.longitude', position.coords.longitude);
                },
                (error) => {
                    var toastEvent = $A.get('e.force:showToast');
                    toastEvent.setParams({
                        'title': 'There has been an error capturing geolocation!',
                        'message': error.message,
                        'type': 'error'
                    });
                    toastEvent.fire();

                    var dismiss = $A.get('e.force:closeQuickAction');
                    dismiss.fire();
                }
            );
        } else {
            var toastEvent = $A.get('e.force:showToast');
            toastEvent.setParams({
                'title': 'There has been an error capturing geolocation!',
                'message': 'Ensure you have enabled geolocation.',
                'type': 'error'
            });
            toastEvent.fire();

            var dismiss = $A.get('e.force:closeQuickAction');
            dismiss.fire();
        }
	},
    
    captureHelper : function(component, event) {
        //obtain recordId
        var accountId = component.get('v.recordId');
        
        //pointer to Apex method in GeolocationController
        var action = component.get('c.updateGeolocation');

        //set parameters for Apex method updateGeolocation
        action.setParams({
            'accountId' : accountId,
            'lat' : component.get('v.latitude'),
            'lng' : component.get('v.longitude')
        });

        //set callback method
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
				alert('Geolocation Saved!');
            }
            else {
                alert('Error saving geolocation!');
            }
        });

        //invoke the Apex method
        $A.enqueueAction(action);

        // reload page to display updated geolocation
        var navigationEvent = $A.get('e.force:navigateToSObject');
        navigationEvent.setParams({
            'recordId': component.get('v.recordId'),
            'slideDevName': 'detail'
        });
        navigationEvent.fire();


        //close quickaction window
        var dismiss = $A.get('e.force:closeQuickAction');
        dismiss.fire();
    }
})