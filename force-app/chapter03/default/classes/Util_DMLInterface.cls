public interface Util_DMLInterface {
    List<Database.SaveResult> insertRecords(List<SObject> recordsToInsert);
    List<Database.SaveResult> updateRecords(List<SObject> recordsToUpdate);
    List<Database.UpsertResult> upsertRecords(List<SObject> recordsToUpsert, String externalIdField);
    List<Database.SaveResult> deleteRecords(List<SObject> recordsToDelete);
    List<Database.SaveResult> undeleteRecords(List<SObject> recordsToUndelete);
    Database.MergeResult mergeRecords(SObject mergeToRecord, SObject duplicateRecord);
}