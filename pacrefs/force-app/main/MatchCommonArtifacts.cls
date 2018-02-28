global class MatchCommonArtifacts implements Database.Batchable<sObject>
{

	global Database.QueryLocator start(Database.BatchableContext BC)
	{
        Set<String> buildArtifactsV3 = new Set<String>();
        Set<String> buildArtifactsV4 = new Set<String>();

        AggregateResult[] arBuildArtifactsV3
          = [SELECT buildArtifact__c from MetaDataUpload__c where buildVersion__c = 'V3' and Ignore_In_Reports__c = false and metadatatype__c ='md' group by buildArtifact__c LIMIT 49999];
        AggregateResult[] arBuildArtifactsV4
          = [SELECT buildArtifact__c from MetaDataUpload__c where buildVersion__c = 'V4' and Ignore_In_Reports__c = false and metadatatype__c ='md'  group by buildArtifact__c LIMIT 49999];

        for (AggregateResult ar : arBuildArtifactsV3)  {
            buildArtifactsV3.add((String) ar.get('buildArtifact__c'));
        }        
        for (AggregateResult ar : arBuildArtifactsV4)  {
            buildArtifactsV4.add((String) ar.get('buildArtifact__c'));
        }        

        String query = 'SELECT Id,CommonBuildArtifact__c FROM MetaDataUpload__c where buildArtifact__c IN :buildArtifactsV3 and buildArtifact__c IN :buildArtifactsV4' ;
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<MetaDataUpload__c> scope)
    {
        for ( MetaDataUpload__c mdu : scope)
        {
            mdu.CommonBuildArtifact__c = true;
        }
        update scope;
    }  

    global void finish(Database.BatchableContext BC)
    {
    }
}