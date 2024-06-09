@IsTest
public with sharing class Util_Mocker {
    public static Object createDMLMock(Type typeToMock) {
        return Test.createStub(typeToMock, new Util_DMLMockProvider());
    }
}