public with sharing class OrgSetupAPI {
    public static HttpResponse getAssets(String searchTerm) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String endpointURL = 'https://collectionapi.metmuseum.org/public/collection/v1/departments';
        request.setEndpoint(endpointURL);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        // If the request is successful, parse the JSON response.

        System.debug(response.getBody());

        return response;
    }
}