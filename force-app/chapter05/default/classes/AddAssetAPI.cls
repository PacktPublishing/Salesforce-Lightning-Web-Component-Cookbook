public with sharing class AddAssetAPI {
    public static String getDepartments() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:The_Met_Named/departments');
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        if(response.getStatusCode() == 200) {
            return response.getBody();
        }
        return null;
    }

    public static String searchByTerm(String searchTerm, Integer departmentId) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:The_Met_Named/search?q=' + String.escapeSingleQuotes(searchTerm) + '&departmentId=' + departmentId);
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        if(response.getStatusCode() == 200) {
            return response.getBody();
        }
        return null;
    }

    public static String getSearchedAssetInfo(Integer objectId) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:The_Met_Named/objects/' + objectId);
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        if(response.getStatusCode() == 200) {
            return response.getBody();
        }
        return null;
    }
}