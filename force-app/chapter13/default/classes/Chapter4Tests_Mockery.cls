@IsTest
public with sharing class Chapter4Tests_Mockery {
    @IsTest
    static void it_should_return_account_wrappers() {
        //prepare
        Account testAccount = new Account(Name = 'Test Account', Id = Util_MockIdGenerator.getMockId(new Account()));

        List<Tag__c> tagsToReturn = new List<Tag__c>();
        for(Integer ii = 0; ii < 10; ii++) {
            Tag__c tag = new Tag__c();
            tag.Name = 'Tag '+ ii;
            tag.Id = Util_MockIdGenerator.getMockId(new Tag__c());
        }

        //arrange
        Mock tagSelectorMock = Mock.forType(TagSelector.class);
        MethodSpy tagsWithAssetsByAccountSpy = tagSelectorMock.spyOn('tagsWithAssetsByAccount');
        AssetsByTagService myAssetsByTagService = new AssetsByTagService();
        myAssetsByTagService.tagSelect = (TagSelector) TagSelectorMock.stub;
        tagsWithAssetsByAccountSpy.returns(tagsToReturn);

        //act
        List<Tag__c> myTags = myAssetsByTagService.getTagsWithAssetsByAccount(testAccount.Id);

        //assert
        for(Integer kk; kk < 10; kk++) {
            Tag__c currentTag = myTags[kk];
            Assert.isTrue(currentTag.Name.contains(String.valueOf(kk)), 'Tags should be in order.');
        }
    }
}