public virtual class Util_DML implements Util_DMLInterface{
    public List<Database.SaveResult> insertRecords(List<SObject> recordsToInsert) {
        List<Database.SaveResult> srList = database.insert(recordsToInsert, false);

        for(Database.SaveResult sr : srList) {
            if(sr.isSuccess() == false) {
                //error processing
            }
        }

        return srList;
    }

    public List<Database.SaveResult> updateRecords(List<SObject> recordsToUpdate) {
        List<Database.SaveResult> srList = database.update(recordsToUpdate, false);

        for(Database.SaveResult sr : srList) {
            if(sr.isSuccess() == false) {
                //error processing
            }
        }

        return srList;
    }

    public List<Database.UpsertResult> upsertRecords(List<SObject> recordsToUpsert, String externalIdField) {
        SObjectField sObjFieldForId = recordsToUpsert[0].getSObjectType().getDescribe().fields.getMap().get(externalIdField);
        
        List<Database.UpsertResult> urList = database.upsert(recordsToUpsert, sObjFieldForId, false);

        for(Database.UpsertResult ur : urList) {
            if(ur.isSuccess() == false) {
                //error processing
            }
        }

        return urList;
    }

    public List<Database.SaveResult> deleteRecords(List<SObject> recordsToDelete) {
        List<Database.SaveResult> srList = database.update(recordsToDelete, false);

        for(Database.SaveResult sr : srList) {
            if(sr.isSuccess() == false) {
                //error processing
            }
        }

        return srList;
    }

    public List<Database.SaveResult> undeleteRecords(List<SObject> recordsToUndelete) {
        List<Database.SaveResult> srList = database.update(recordsToUndelete, false);

        for(Database.SaveResult sr : srList) {
            if(sr.isSuccess() == false) {
                //error processing
            }
        }

        return srList;
    }

    public Database.MergeResult mergeRecords(SObject mergeToRecord, SObject duplicateRecord) {
        Database.MergeResult mr = database.merge(mergeToRecord, duplicateRecord);

        if(mr.isSuccess() == false) {
            //error processing
        }

        return mr;
    }
}