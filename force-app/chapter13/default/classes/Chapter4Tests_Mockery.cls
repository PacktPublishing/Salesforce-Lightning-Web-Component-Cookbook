@IsTest
public with sharing class Chapter4Tests_Mockery {
    @IsTest
    static void controller_it_should_return_tags() {
        //prepare
        Account testAccount = new Account(Name = 'Test Account', Id = Util_FakeIdGenerator.getFakeId(new Account()));

        List<Tag__c> tagsToReturn = new List<Tag__c>();
        for(Integer ii = 0; ii < 10; ii++) {
            Tag__c tag = new Tag__c();
            tag.Name = 'Tag '+ ii;
            tag.Id = Util_FakeIdGenerator.getFakeId(new Tag__c());

            tagsToReturn.add(tag);
        }

        //arrange
        Mock utilQueryMock = Mock.forType(Util_Query.class);
        MethodSpy querySpy = utilQueryMock.spyOn('query');
        TagSelector myTagSelector = new TagSelector();
        querySpy.returnsOnce(tagsToReturn);

        //act
        List<Tag__c> myTags = AssetsByTagController.returnTagsWithAssetsByAccount(testAccount.Id);

        //assert
        for(Integer kk; kk < 10; kk++) {
            Tag__c currentTag = myTags[kk];
            Assert.isTrue(currentTag.Name.contains(String.valueOf(kk)), 'Tags should be in order.');
        }
    }

    @IsTest
    static void controller_it_should_return_tag_wrappers() {
        //prepare
        Account testAccount = new Account(Name = 'Test Account', Id = Util_FakeIdGenerator.getFakeId(new Account()));

        List<Tag__c> tagsToReturn = new List<Tag__c>();
        for(Integer ii = 0; ii < 10; ii++) {
            Tag__c tag = new Tag__c();
            tag.Name = 'Tag '+ ii;
            tag.Id = Util_FakeIdGenerator.getFakeId(new Tag__c());
            
            tagsToReturn.add(tag);
        }

        //arrange
        Mock utilQueryMock = Mock.forType(Util_Query.class);
        MethodSpy querySpy = utilQueryMock.spyOn('query');
        TagSelector myTagSelector = new TagSelector();
        querySpy.returnsOnce(tagsToReturn);

        //act
        List<AssetsByTagService.AssetWrapperCh04> myTagWrappers = AssetsByTagController.returnTagsWithAssetsWrappersByAccount(testAccount.Id);

        //assert
        for(Integer kk; kk < 10; kk++) {
            AssetsByTagService.AssetWrapperCh04 currentWrapper = myTagWrappers[kk];
            Assert.isTrue(currentWrapper.tagName.contains(String.valueOf(kk)), 'Tags should be in order.');
        }
    }

    @IsTest
    static void service_it_should_return_tags() {
        //prepare
        Account testAccount = new Account(Name = 'Test Account', Id = Util_FakeIdGenerator.getFakeId(new Account()));

        List<Tag__c> tagsToReturn = new List<Tag__c>();
        for(Integer ii = 0; ii < 10; ii++) {
            Tag__c tag = new Tag__c();
            tag.Name = 'Tag '+ ii;
            tag.Id = Util_FakeIdGenerator.getFakeId(new Tag__c());

            tagsToReturn.add(tag);
        }

        //arrange
        Mock tagSelectorMock = Mock.forType(TagSelector.class);
        MethodSpy tagsWithAssetsByAccountSpy = tagSelectorMock.spyOn('tagsWithAssetsByAccount');
        AssetsByTagService myAssetsByTagService = new AssetsByTagService();
        myAssetsByTagService.tagSelect = (TagSelector) TagSelectorMock.stub;
        tagsWithAssetsByAccountSpy.returnsOnce(tagsToReturn);

        //act
        List<Tag__c> myTags = myAssetsByTagService.getTagsWithAssetsByAccount(testAccount.Id);

        //assert
        for(Integer kk; kk < 10; kk++) {
            Tag__c currentTag = myTags[kk];
            Assert.isTrue(currentTag.Name.contains(String.valueOf(kk)), 'Tags should be in order.');
        }
    }

    @IsTest
    static void service_it_should_return_tag_wrappers() {
        //prepare
        Account testAccount = new Account(Name = 'Test Account', Id = Util_FakeIdGenerator.getFakeId(new Account()));

        List<Tag__c> tagsToReturn = new List<Tag__c>();
        for(Integer ii = 0; ii < 10; ii++) {
            Tag__c tag = new Tag__c();
            tag.Name = 'Tag '+ ii;
            tag.Id = Util_FakeIdGenerator.getFakeId(new Tag__c());

            tagsToReturn.add(tag);
        }

        //arrange
        Mock tagSelectorMock = Mock.forType(TagSelector.class);
        MethodSpy tagsWithAssetsByAccountSpy = tagSelectorMock.spyOn('tagsWithAssetsByAccount');
        AssetsByTagService myAssetsByTagService = new AssetsByTagService();
        myAssetsByTagService.tagSelect = (TagSelector) TagSelectorMock.stub;
        tagsWithAssetsByAccountSpy.returns(tagsToReturn);

        //act
        List<AssetsByTagService.AssetWrapperCh04> myTagWrappers = myAssetsByTagService.getTagsWithAssetsWrappersByAccount(testAccount.Id);

        //assert
        for(Integer kk; kk < 10; kk++) {
            AssetsByTagService.AssetWrapperCh04 currentWrapper = myTagWrappers[kk];
            Assert.isTrue(currentWrapper.tagName.contains(String.valueOf(kk)), 'Tags should be in order.');
        }
    }

    @IsTest
    static void selector_it_should_return_tags() {
        //prepare
        Account testAccount = new Account(Name = 'Test Account', Id = Util_FakeIdGenerator.getFakeId(new Account()));

        List<Tag__c> tagsToReturn = new List<Tag__c>();
        for(Integer ii = 0; ii < 10; ii++) {
            Tag__c tag = new Tag__c();
            tag.Name = 'Tag '+ ii;
            tag.Id = Util_FakeIdGenerator.getFakeId(new Tag__c());

            tagsToReturn.add(tag);
        }

        //arrange
        Mock utilQueryMock = Mock.forType(Util_Query.class);
        MethodSpy querySpy = utilQueryMock.spyOn('query');
        TagSelector myTagSelector = new TagSelector();
        querySpy.returnsOnce(tagsToReturn);

        //act
        List<Tag__c> myTags = myTagSelector.tagsWithAssetsByAccount(testAccount.Id);

        //assert
        for(Integer kk; kk < 10; kk++) {
            Tag__c currentTag = myTags[kk];
            Assert.isTrue(currentTag.Name.contains(String.valueOf(kk)), 'Tags should be in order.');
        }
    }
}