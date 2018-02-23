public class MetadataParser {

    public MetadataParser() {
    }

    public static String PACKAGE_PREFIX = 'ACCL';
    public static String[] TERMINATORS = new String[] {'__c','.'};

    public String metadataType;
    public String category;
    public String rawText;
    public String buildArtifact;
    public String packageComponent;
    public String packageComponentParent;

    public List<MetaDataUpload__c> parse (String s) {
        List<MetaDataUpload__c> listmdu = new List<MetaDataUpload__c>();

        this.rawText = s.substringAfter(':');
        this.metadataType = s.substring(2).substringBetween('.',':');
        this.buildArtifact = s.substring(2).substringBetween('/','.');
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
            List<String> rawSplit = splitByPrefix(rawNormal, PACKAGE_PREFIX);
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

    public static List<String> splitByPrefix (String s, String packagePrefix)
    {
        List<String> retArray = new List<String>{};
        String rawNormal = s.normalizeSpace().substringAfter(PACKAGE_PREFIX);
        String[] rawSplit = rawNormal.split(PACKAGE_PREFIX);

        for (Integer i = 0; i < rawSplit.size(); i++)
        {
            retArray.add(PACKAGE_PREFIX + rawSplit[i]);
        }
        return retArray;
    }


    public static String stripToReference (String s, String terminator) 
    {
        String retString = s.normalizeSpace();
        Integer indexTerminator = s.indexOf(terminator);
        if (indexTerminator > 0) {
            retString = s.substring(0,indexTerminator) + terminator;
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