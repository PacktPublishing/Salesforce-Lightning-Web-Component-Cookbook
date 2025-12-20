({
	findGeolocation : function(component, event) {
		//finds the geolocation of the user's device
		//prompts user to allow location access if not already allowed
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(success);
            function success(position) {
                var lat = position.coords.latitude;
                component.set("v.latitude", lat);
                var lng = position.coords.longitude;
                component.set("v.longitude", lng);
                console.log(lat, lng)
            }
        } else {
            error('Geolocation is not supported');
        }
	},
    
    captureHelper : function(component, event) {
        //obtain recordId
        var leadId = component.get("v.recordId");
        //pointer to Apex method in GeolocationController
        var action = component.get("c.updateGeolocation");
        //set parameters for Apex method updateGeolocation
        action.setParams({
            "accountId" : leadId,
            "lat" : component.get("v.latitude"),
            "lng" : component.get("v.longitude")
        });
        //set callback method
        action.setCallback(this, function(response) {
            var state = response.getState(); //fetch the response state
            if (state === "SUCCESS") {
				alert("Geolocation saved.")
            }
            else {
                alert("Geolocation not saved.");
            }
        });
        //invoke the Apex method
        $A.enqueueAction(action);
        //close quickaction window
        $A.get("e.force:closeQuickAction").fire();
        //reload page to display updated geolocation
        window.location.reload();
    }
})