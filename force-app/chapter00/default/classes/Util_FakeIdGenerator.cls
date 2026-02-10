public with sharing class Util_FakeIdGenerator {
	private static Integer idsGenerated = 0;

    public static Id getFakeId(SObject sObj) {
        return getFakeId(sObj.getSObjectType());
    }

    public static Id getFakeId(SObjectType sObjType) {
        idsGenerated++;
        String keyPrefix = sObjType.getDescribe().getKeyPrefix();
        String idsGenStr = String.valueOf(idsGenerated);

        return Id.valueOf(keyPrefix + idsGenStr.leftPad(12, '0'));
    }
}