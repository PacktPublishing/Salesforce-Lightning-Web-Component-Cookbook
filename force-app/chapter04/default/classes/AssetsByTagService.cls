public with sharing class AssetsByTagService {
    public List<Tag__c> getTagsWithAssetsByAccount(Id accountId){
        return new TagSelector().tagsWithAssetsByAccount(accountId);
    }

    public List<AssetWrapperCh04> getTagsWithAssetsWrappersByAccount(Id accountId){
        List<Tag__c> tagList = new TagSelector().tagsWithAssetsByAccount(accountId);
        List<AssetWrapperCh04> assetWrapperList = new List<AssetWrapperCh04>();

        for(Tag__c tag : tagList) {
            TagWrapperCh04 wrappedTag = new TagWrapperCh04(tag);

            assetWrapperList.addAll(wrappedTag.assets);
        }

        return assetWrapperList;
    }

    public class TagWrapperCh04 {
        @AuraEnabled public List<AssetWrapperCh04> assets;

        public TagWrapperCh04(Tag__c tagToWrap) {
            this.assets = new List<AssetWrapperCh04>();

            for(Asset ast : tagToWrap.Assets__r) {
                AssetWrapperCh04 assetWrapper = new AssetWrapperCh04(ast);
                assetWrapper.tagId = tagToWrap.Id;
                assetWrapper.tagName = tagToWrap.Name;
                this.assets.add(assetWrapper);
            }
        }
    }

    public class AssetWrapperCh04 {
        @AuraEnabled public String tagId;
        @AuraEnabled public String tagName;
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