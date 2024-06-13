public with sharing class Util_Mocker {
    public static Object createMock(Type typeToMock) {
        switch on String.valueOf(typeToMock) {
            when 'Util_DML' {
                return Test.createStub(typeToMock, new Util_DMLMockProvider());
            }
            when 'Util_Query' {
                return Test.createStub(typeToMock, new Util_QueryMockProvider());
            }
            when 'AccountSelector' {
                return Test.createStub(typeToMock, new AccountSelectorMockProvider());
            }
            when else {
                return null;
            }
        }
    }
}