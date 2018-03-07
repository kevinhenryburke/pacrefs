@isTest 
public class Batchables_Test 
{
    @IsTest static void testSetFunctionalArea() 
    {
        String REPORT_TYPE_SAMPLE = './pages/TPM_CreatePromotion.page:                    <apex:outputLabel value="{!$ObjectType.ACCL__Promotion__c.Fields.ACCL__Promotion_Template__c.Label}"';
        List<MetaDataUpload__c> listmdu = new List<MetaDataUpload__c>();

        MetadataParser mdp = new MetadataParser();
        MetaDataUpload__c mdu = mdp.parse(REPORT_TYPE_SAMPLE)[0];
        listmdu.add(mdu);
        
        insert listmdu;
        
        Test.startTest();
        SetFunctionalArea obj = new SetFunctionalArea();
        DataBase.executeBatch(obj); 
        Test.stopTest();
    }

    @IsTest static void testDeleteAnalysisRecords() 
    {
        String REPORT_TYPE_SAMPLE = './pages/TPM_CreatePromotion.page:                    <apex:outputLabel value="{!$ObjectType.ACCL__Promotion__c.Fields.ACCL__Promotion_Template__c.Label}"';
        List<MetaDataUpload__c> listmdu = new List<MetaDataUpload__c>();

        MetadataParser mdp = new MetadataParser();
        MetaDataUpload__c mdu = mdp.parse(REPORT_TYPE_SAMPLE)[0];
        listmdu.add(mdu);
        
        insert listmdu;
        
        Test.startTest();
        DeleteAnalysisRecords obj = new DeleteAnalysisRecords();
        obj.query = 'select id from MetaDataUpload__c';
        DataBase.executeBatch(obj); 
        Test.stopTest();
    }

    @IsTest static void testMatchCommonArtifacts() 
    {
        String REPORT_TYPE_SAMPLE = './pages/TPM_CreatePromotion.page:                    <apex:outputLabel value="{!$ObjectType.ACCL__Promotion__c.Fields.ACCL__Promotion_Template__c.Label}"';
        List<MetaDataUpload__c> listmdu = new List<MetaDataUpload__c>();

        MetadataParser mdp = new MetadataParser();
        MetaDataUpload__c mdu = mdp.parse(REPORT_TYPE_SAMPLE)[0];
        listmdu.add(mdu);
        
        insert listmdu;
        
        Test.startTest();
        MatchCommonArtifacts obj = new MatchCommonArtifacts();
        DataBase.executeBatch(obj); 
        Test.stopTest();
    }

    @IsTest static void testProcessAnalysisRecords() 
    {
        String REPORT_TYPE_SAMPLE = './pages/TPM_CreatePromotion.page:                    <apex:outputLabel value="{!$ObjectType.ACCL__Promotion__c.Fields.ACCL__Promotion_Template__c.Label}"';
        List<GrepLine__c> lines = new List<GrepLine__c>();
        GrepLine__c gl = new GrepLine__c(fileLine__c = REPORT_TYPE_SAMPLE);
        insert lines;
        
        Test.startTest();
        ProcessAnalysisRecords obj = new ProcessAnalysisRecords();
        DataBase.executeBatch(obj); 
        Test.stopTest();
    }

    @IsTest static void testSetFunctionalAreaTrigger() 
    {
        String REPORT_TYPE_SAMPLE = './pages/TPM_CreatePromotion.page:                    <apex:outputLabel value="{!$ObjectType.ACCL__Promotion__c.Fields.ACCL__Promotion_Template__c.Label}"';
        List<MetaDataUpload__c> listmdu = new List<MetaDataUpload__c>();
        MetadataParser mdp = new MetadataParser();
        MetaDataUpload__c mdu = mdp.parse(REPORT_TYPE_SAMPLE)[0];
        listmdu.add(mdu);
        
        insert listmdu;
        
        Test.startTest();
        MetaDataJobRunner__c mdjr = new MetaDataJobRunner__c(JobName__c = 'SetFunctionalArea');
        insert mdjr;
        Test.stopTest();
    }

    @IsTest static void testDeleteAnalysisRecordsTrigger() 
    {
        String REPORT_TYPE_SAMPLE = './pages/TPM_CreatePromotion.page:                    <apex:outputLabel value="{!$ObjectType.ACCL__Promotion__c.Fields.ACCL__Promotion_Template__c.Label}"';
        List<MetaDataUpload__c> listmdu = new List<MetaDataUpload__c>();

        MetadataParser mdp = new MetadataParser();
        MetaDataUpload__c mdu = mdp.parse(REPORT_TYPE_SAMPLE)[0];
        listmdu.add(mdu);
        
        insert listmdu;
        
        Test.startTest();
        MetaDataJobRunner__c mdjr = new MetaDataJobRunner__c(JobName__c = 'ClearMetaDataUploads');
        insert mdjr;
        Test.stopTest();
    }

    @IsTest static void testDeleteAnalysisRecordsTriggerStaging() 
    {
        String REPORT_TYPE_SAMPLE = './pages/TPM_CreatePromotion.page:                    <apex:outputLabel value="{!$ObjectType.ACCL__Promotion__c.Fields.ACCL__Promotion_Template__c.Label}"';
        List<MetaDataUpload__c> listmdu = new List<MetaDataUpload__c>();

        MetadataParser mdp = new MetadataParser();
        MetaDataUpload__c mdu = mdp.parse(REPORT_TYPE_SAMPLE)[0];
        listmdu.add(mdu);
        
        insert listmdu;
        
        Test.startTest();
        MetaDataJobRunner__c mdjr = new MetaDataJobRunner__c(JobName__c = 'ClearStaging');
        insert mdjr;
        Test.stopTest();
    }

    @IsTest static void testMatchCommonArtifactsTrigger() 
    {
        String REPORT_TYPE_SAMPLE = './pages/TPM_CreatePromotion.page:                    <apex:outputLabel value="{!$ObjectType.ACCL__Promotion__c.Fields.ACCL__Promotion_Template__c.Label}"';
        List<MetaDataUpload__c> listmdu = new List<MetaDataUpload__c>();

        MetadataParser mdp = new MetadataParser();
        MetaDataUpload__c mdu = mdp.parse(REPORT_TYPE_SAMPLE)[0];
        listmdu.add(mdu);
        
        insert listmdu;
        
        Test.startTest();
        MetaDataJobRunner__c mdjr = new MetaDataJobRunner__c(JobName__c = 'MatchCommonArtifacts');
        insert mdjr;
        Test.stopTest();
    }

    @IsTest static void testProcessAnalysisRecordsTriggerV3() 
    {
        String REPORT_TYPE_SAMPLE = './pages/TPM_CreatePromotion.page:                    <apex:outputLabel value="{!$ObjectType.ACCL__Promotion__c.Fields.ACCL__Promotion_Template__c.Label}"';
        List<GrepLine__c> lines = new List<GrepLine__c>();
        GrepLine__c gl = new GrepLine__c(fileLine__c = REPORT_TYPE_SAMPLE);
        insert lines;
        
        Test.startTest();
        MetaDataJobRunner__c mdjr = new MetaDataJobRunner__c(JobName__c = 'V3Process');
        insert mdjr;
        Test.stopTest();
    }

    @IsTest static void testProcessAnalysisRecordsTriggerV4() 
    {
        String REPORT_TYPE_SAMPLE = './pages/TPM_CreatePromotion.page:                    <apex:outputLabel value="{!$ObjectType.ACCL__Promotion__c.Fields.ACCL__Promotion_Template__c.Label}"';
        List<GrepLine__c> lines = new List<GrepLine__c>();
        GrepLine__c gl = new GrepLine__c(fileLine__c = REPORT_TYPE_SAMPLE);
        insert lines;
        
        Test.startTest();
        MetaDataJobRunner__c mdjr = new MetaDataJobRunner__c(JobName__c = 'V4Process');
        insert mdjr;
        Test.stopTest();
    }


}
