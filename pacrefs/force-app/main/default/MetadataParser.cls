public class MetadataParser {

    public MetadataParser() {
    }

    public static String PACKAGE_PREFIX = 'ACCL';
    public static String CUSTOMER_PREFIX = 'TPM';
    public static String[] TERMINATORS = new String[] {'__c','.',' ','(',')','<','$','/'};

    public String metadataType;
    public String category;
    public String rawText;
    public String buildArtifact;
    public String packageComponent;
    public String packageComponentParent;

    public List<MetaDataUpload__c> parse (String s) {
        List<MetaDataUpload__c> listmdu = new List<MetaDataUpload__c>();

        this.rawText = s.substringAfter(':');

        this.buildArtifact = s.substring(2).substringBetween('/','.');
        this.metadataType = s.substring(2).substringBetween('.',':');
        while (this.metadataType != null && this.metadataType.contains('.')) {
            this.buildArtifact += '.' + this.metadataType.substringBefore('.');
            this.metadataType = this.metadataType.substringAfter('.');
        }

        if (getMetadataTypeOverride(s, this.metadataType) != null) {
            this.metadataType = getMetadataTypeOverride(s, this.metadataType);
        }

        this.category = '';

        // find by tag field
        if (this.rawText.contains('<field>')) {
            String fieldText = this.rawText.substringBetween('<field>','</field>');
            if (fieldText.contains('.')) {
                this.packageComponentParent = fieldText.substringBefore('.');
                this.packageComponent = fieldText.substringAfter('.');
            }
            else {
                this.packageComponent = fieldText;
            }
            MetaDataUpload__c mdu = new MetaDataUpload__c();
            mdu.packageComponent__c = this.packageComponent;
            mdu.packageComponentParent__c = this.packageComponentParent;
            listmdu.add(mdu);
        }
        else {
        // find by PACKAGE_PREFIX
            String rawNormal = this.rawText.normalizeSpace();
            List<String> rawSplit = splitByPrefix(rawNormal, PACKAGE_PREFIX, CUSTOMER_PREFIX);
            for (String packageComponent : rawSplit)
            {
                MetaDataUpload__c mdu = new MetaDataUpload__c();
                mdu.packageComponent__c = stripToFirstReference(packageComponent,TERMINATORS);
                listmdu.add(mdu);
            }
        }

        for (MetaDataUpload__c mdu : listmdu)
        {
            mdu.rawText__c = this.rawText;
            mdu.metadataType__c = this.metadataType;
            mdu.buildArtifact__c = this.buildArtifact;
            mdu.category__c = this.category;
            mdu.ignore_in_reports__c = ignore(mdu);
        }

        return listmdu;
    }

    public static List<String> splitByPrefix (String s, String packagePrefix, String companyPrefix)
    {
        List<String> retArray = new List<String>{};
        String remains = s.normalizeSpace();
        Boolean done = false;

        while (!done) {
            Integer packagePrefixIndex = remains.indexOf(packagePrefix);
            Integer companyPrefixIndex = remains.indexOf(companyPrefix);
            Integer firstIndex = -1; 
            
            if (packagePrefixIndex > -1){
                firstIndex = packagePrefixIndex;
            }
            if (companyPrefixIndex > -1 && (packagePrefixIndex == -1 || companyPrefixIndex < packagePrefixIndex)){
                firstIndex = companyPrefixIndex;
            }

            if (firstIndex > -1) {
                String firstPrefix = (packagePrefixIndex == firstIndex)? packagePrefix : companyPrefix;
                remains = remains.substringAfter(firstPrefix);
                retArray.add(firstPrefix + stripToFirstReference(remains,TERMINATORS));
            }
            else {
                done = true;
            }
        }

        return retArray;
    }


    public static String stripToReference (String s, String terminator) 
    {
        String retString = s.normalizeSpace();
        Integer indexTerminator = s.indexOf(terminator);
        if (indexTerminator > 0) {
            retString = s.substring(0,indexTerminator);
            if (terminator == '__c')
            {
                retString += terminator;
            }
        }
        return retString;
    }

    public static String stripToFirstReference (String s, String[] terminators)
    {
        String terminated = s;
        for (String terminator : terminators)
        {
            String iterated = stripToReference (s, terminator); 
            if (iterated.length() < terminated.length())
            {
                terminated = iterated;
            }
        }
        if (terminated != null && terminated.length() > 50)
        {
            return terminated.substring(0,50);
        }
        return terminated;
    }

    public static String getCategory (String sMetaDataType)
    {
        return null;
    }

    public static Boolean ignore (MetaDataUpload__c mdu)
    {
        Boolean retBoolean = false;    
        if (mdu.metadataType__c == 'cls' && mdu.buildArtifact__c.contains('Test'))
        {
            retBoolean = true;
        }
        return retBoolean;    
    }

    public static String getMetadataTypeOverride(String s, String metadataType)
    {
        if (s.contains('errorConditionFormula') && metadataType == 'object') {
            return 'validationRule';
        }
        if (s.contains('fullName') && metadataType == 'object') {
            return 'customField';
        }
        return null;
    }

}





/* 

    // Some helper variables to fix locations. If for example we have the string
    // ./reportTypes/Account_with_Applications.reportType:
    // then we need variable to identify the last : . and / to populate the class variables.
    // TODO may not need.
    public Integer fileNameEndLocation;
    public Integer fileTypeSeparatorLocation;
    public Integer directorySeparatorLocation;
        mdp.fileNameEndLocation = s.indexOf(':');
        mdp.fileTypeSeparatorLocation = s.substring(2).indexOf('.') + 2;
        mdp.directorySeparatorLocation = s.substring(2).indexOf('/') + 2;

*/