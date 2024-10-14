public with sharing class AssetsByTagService {
    public List<Tag__c> getTagsWithAssetsByAccount(Id accountId, Integer lim, Integer offset){
        try {
            return new TagSelector().tagsWithAssetsByAccount(accountId, lim, offset);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public List<TagWrapperCh04> getTagsWithAssetsWrappersByAccount(Id accountId, Integer lim, Integer offset){
        try {
            List<Tag__c> tagList = new TagSelector().tagsWithAssetsByAccount(accountId, lim, offset);
            List<TagWrapperCh04> wrapperList = new List<TagWrapperCh04>();

            for(Tag__c tag : tagList) {
                TagWrapperCh04 wrappedTag = new TagWrapperCh04(tag);

                wrapperList.add(wrappedTag);
            }

            return wrapperList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class TagWrapperCh04 {
        @AuraEnabled public String tagId;
        @AuraEnabled public String tagName;
        @AuraEnabled public List<AssetWrapperCh04> assets;

        public TagWrapperCh04(Tag__c tagToWrap) {
            this.tagId = tagToWrap.Id;
            this.tagName = tagToWrap.Name;
            List<AssetWrapperCh04> assets = new List<AssetWrapperCh04>();

            for(Asset ast : tagToWrap.Assets__r) {
                AssetWrapperCh04 assetWrapper = new AssetWrapperCh04(ast);
                assets.add(assetWrapper);
            }
        }
    }

    public class AssetWrapperCh04 {
        @AuraEnabled public String assetId;
        @AuraEnabled public String assetName;
        @AuraEnabled public String assetDepartment;
        @AuraEnabled public String assetDescription;
        @AuraEnabled public String assetObjectId;
        @AuraEnabled public Boolean assetIsPublicDomain;
        @AuraEnabled public String assetPrimaryImage;
        
        public AssetWrapperCh04(Asset ast) {
            this.assetId = ast.Id;
            this.assetName = ast.Name;
            this.assetDepartment = ast.Department__c;
            this.assetDescription = ast.Description;
            this.assetIsPublicDomain = ast.Is_Public_Domain__c;
            this.assetObjectId = ast.Object_Id__c;
            this.assetPrimaryImage = ast.Primary_Image__c;
        }
    }
}