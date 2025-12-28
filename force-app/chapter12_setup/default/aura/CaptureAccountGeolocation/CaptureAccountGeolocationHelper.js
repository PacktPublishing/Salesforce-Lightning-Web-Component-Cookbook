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

                    $A.get('e.force:closeQuickAction').fire();
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

            $A.get('e.force:closeQuickAction').fire();   
        }
	},
    
    captureHelper : function(component, event) {
        try {
            //reference to Apex method in CaptureAccountGeolocationController
            var action = component.get('c.updateGeolocation');

            //set parameters for Apex method updateGeolocation
            action.setParams({
                'accountId' : component.get('v.recordId'),
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
                    throw new Error('There has been an error capturing geolocation!');
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
            $A.get('e.force:closeQuickAction').fire();
        } catch(error) {
            var toastEvent = $A.get('e.force:showToast');
            toastEvent.setParams({
                'title': 'There has been an error capturing geolocation!',
                'message': error.message,
                'type': 'error'
            });
            toastEvent.fire();
        }
    }
})