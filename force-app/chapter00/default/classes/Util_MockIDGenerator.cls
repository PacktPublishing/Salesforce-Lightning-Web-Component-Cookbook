public with sharing class Util_MockIDGenerator {
	private static Integer idsGenerated = 0;

    public static Id getMockId(SObject sObj) {
        return getMockId(sObj.getSObjectType());
    }

    public static Id getMockId(SObjectType sObjType) {
        idsGenerated++;
        String keyPrefix = sObjType.getDescribe().getKeyPrefix();
        String idsGenStr = String.valueOf(idsGenerated);

        return Id.valueOf(keyPrefix + idsGenStr.leftPad(12, '0'));
    }
}