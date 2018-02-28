trigger MetaDataJobRunner_InsertTrigger on MetaDataJobRunner__c (before insert) {
/*
V3Process
V4Process
ClearMetaDataUploads
ClearGrepLines    
*/
    for (MetaDataJobRunner__c mdjr : Trigger.new)
    {
        if (mdjr.JobName__c == 'V3Process')
        {
            ProcessAnalysisRecords par = new ProcessAnalysisRecords();
            par.version = 'V3';
            ID batchprocessid = Database.executeBatch(par);
        }
        if (mdjr.JobName__c == 'V4Process')
        {
            ProcessAnalysisRecords par = new ProcessAnalysisRecords();
            par.version = 'V4';
            ID batchprocessid = Database.executeBatch(par);
        }
        if (mdjr.JobName__c == 'ClearGrepLines')
        {
            DeleteAnalysisRecords dar = new DeleteAnalysisRecords();
            dar.query = 'select id from GrepLine__c';
            ID batchprocessid = Database.executeBatch(dar);
            
        }
        if (mdjr.JobName__c == 'ClearMetaDataUploads')
        {
            DeleteAnalysisRecords dar = new DeleteAnalysisRecords();
            dar.query = 'select id from MetaDataUpload__c';
            ID batchprocessid = Database.executeBatch(dar);
        }
    }

}