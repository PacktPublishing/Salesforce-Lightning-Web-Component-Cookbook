({
    doInit : function(component, event, helper) {
        helper.findGeolocation(component, event, helper);
    },
    
    captureGeolocation : function(component, event, helper) {
        helper.captureHelper(component, event);
    }
})