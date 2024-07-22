public virtual class Util_DML {
    public List<Database.SaveResult> insertRecords(List<SObject> recordsToInsert) {
        List<Database.SaveResult> srList = Database.insert(recordsToInsert, false);

        for(Database.SaveResult sr : srList) {
            if(sr.isSuccess() == false) {
                //error processing
            }
        }

        return srList;
    }

    public List<Database.SaveResult> updateRecords(List<SObject> recordsToUpdate) {
        List<Database.SaveResult> srList = Database.update(recordsToUpdate, false);

        for(Database.SaveResult sr : srList) {
            if(sr.isSuccess() == false) {
                //error processing
            }
        }

        return srList;
    }

    public List<Database.UpsertResult> upsertRecords(List<SObject> recordsToUpsert, String externalIdField) {
        SObjectField sObjFieldForId = recordsToUpsert[0].getSObjectType().getDescribe().fields.getMap().get(externalIdField);
        
        List<Database.UpsertResult> urList = Database.upsert(recordsToUpsert, sObjFieldForId, false);

        for(Database.UpsertResult ur : urList) {
            if(ur.isSuccess() == false) {
                //error processing
            }
        }

        return urList;
    }

    public List<Database.SaveResult> deleteRecords(List<SObject> recordsToDelete) {
        List<Database.SaveResult> srList = Database.update(recordsToDelete, false);

        for(Database.SaveResult sr : srList) {
            if(sr.isSuccess() == false) {
                //error processing
            }
        }

        return srList;
    }

    public List<Database.SaveResult> undeleteRecords(List<SObject> recordsToUndelete) {
        List<Database.SaveResult> srList = Database.update(recordsToUndelete, false);

        for(Database.SaveResult sr : srList) {
            if(sr.isSuccess() == false) {
                //error processing
            }
        }

        return srList;
    }

    public Database.MergeResult mergeRecords(SObject mergeToRecord, SObject duplicateRecord) {
        Database.MergeResult mr = Database.merge(mergeToRecord, duplicateRecord);

        if(mr.isSuccess() == false) {
            //error processing
        }

        return mr;
    }
}