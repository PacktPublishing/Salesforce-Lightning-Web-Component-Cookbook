({
    doInit : function(component, event, helper) {
        helper.findGeolocation(component, event, helper);
        console.log('doInit called');
    },
    
    captureGeolocation : function(component, event, helper) {
        helper.captureHelper(component, event);
        console.log('captureGeolocation called');
    }
})