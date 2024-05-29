public with sharing class ObjectWrappers {
    public class AssetWrapper {
        public String accessionNumber;
        public Integer accessionYear;
        public Boolean isPublicDomain;
        public Id accountId;
        public String title;
        public String objectURL;
        public String objectWikidata_URL;
        public String classification;
        public String culture;
        public String department;
        public Boolean isHighlight;
        public String medium;
        public String objectId;
        public String period;
        public List<constituentWrapper> constituents;
        public String primaryImage;
        public String primaryImageSmall;
        public List<tagWrapper> tags;
    }

    public class ConstituentWrapper {
        public String constituentID;
        public String role;
        public String name;
        public String constituentULAN_URL;
        public String constituentWikidata_URL;
        public String gender;
    }

    public class TagWrapper {
        public String term;
        public String AAT_URL;
        public String Wikidata_URL;
    }
}