public with sharing class Util_MockIDGenerator {
    public SObjectType mockedSObjType {get; private set;}

    public Util_MockIDGenerator(SObjectType sObjType) {
        this.mockedSObjType = sObjType;
    }

    public Util_MockIDGenerator(SObject sObj) {
        this.mockedSObjType = sObj.getSObjectType();
    }

    public static Id getMockId(SObject sObj) {
        return getMockId(sObj.getSObjectType());
    }

    public static Id getMockId(SObjectType sObjType) {
        String keyPrefix = sObjType.getDescribe().getKeyPrefix();

        String idToReturn = keyPrefix;

        for(Integer ii = 0; ii < 15; ii++) {
            idToReturn += Math.round(Math.random() * 9);
        }

        return idToReturn;
    }
}