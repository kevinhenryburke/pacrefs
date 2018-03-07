trigger MetaDataJobRunner_InsertTrigger on MetaDataJobRunner__c (before insert) {

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
        if (mdjr.JobName__c == 'ClearStaging')
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
        if (mdjr.JobName__c == 'MatchCommonArtifacts')
        {
            MatchCommonArtifacts mca = new MatchCommonArtifacts();
            ID batchprocessid = Database.executeBatch(mca);
        }
        if (mdjr.JobName__c == 'SetFunctionalArea')
        {
            SetFunctionalArea sfa = new SetFunctionalArea();
            ID batchprocessid = Database.executeBatch(sfa);
        }

    }

}