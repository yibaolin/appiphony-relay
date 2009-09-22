/************************************************************
	DocUtils caches the Org Id for all doc used in classes
	through this Utility.
************************************************************/
public with Sharing class DocumentUtil {

	public static DocumentUtil instance = null;
	public Id orgID{get; set;}
	public Document doc;
	public static Document doc = null; 
	
	public DocumentUtil() {
		orgID = [SELECT Id FROM Organization].Id;
	}
	
	public String getURL() {
		return getURL(doc);
	}
	
	public String getURL(Document d) {
		// Rewrite as a relative path.
		String URL = '/servlet/servlet.ImageServer?id=' + d.id + '&oid=' + orgID;	
		return URL;
	}
	
	public static DocumentUtil getInstance() {
		if (doc == null) {
			doc = new Document();
		}
		return getInstance(doc);
 	}
	
	public static DocumentUtil getInstance(Document d) {
		if (instance == null) {
			instance = new DocumentUtil();
		}
		instance.doc = d;
		return instance;
	}
}