public with sharing class Util_DMLMocker {
    public static Util_DMLMockProvider getMock() {
        return new Util_DMLMockProvider();
    }

    public static Object createMock(Type typeToMock) {
        return Test.createStub(typeToMock, Util_DMLMocker.getMock());
    }
}