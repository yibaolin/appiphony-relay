/************************************************************
	FileUpload was part of the file upload sample code
	that we've modified.
************************************************************/
public with sharing class FileUpload {
	public Document document {get; set;}
	public String url {get; set;}
	public boolean hasImage {get; set;}
	
	public FileUpload() {
		hasImage = false;
		document = new document();
	}

	public PageReference doUpload() {

		if (document.body != null) {
	        System.debug('@@@@@@@@ document:' + document.name);
	        
	        if (document.name != null) {
		     	System.debug('@@@@@@@@ doSave');
		        
		        Document d = document;
		        System.debug(document);
		        System.debug('@@@@@@@@ document name: '+d.name);
		        System.debug(d);
		
		        d.folderid = UserInfo.getUserId(); //store in Personal Documents
		        System.debug('@@@@@@@@ document folder id: '+d.folderid);
		        d.IsPublic = true;
		        
		        try {
		        	insert d;
		        	url = DocumentUtil.getInstance().getURL(d);
		        	hasImage = true;
		        } catch (Exception e) {
		        	ApexPages.addMessages(e);
		        	url = '';
		        }
		        
		        d.body = null;
		    
		        System.debug('@@@@@@@@ document object id: '+d.id);
		        String url = DocumentUtil.getInstance(d).getURL();
		        System.debug('######## document content type: '+d.type);        
	        }
		        
	
	    }
     	
     	PageReference page = new PageReference('/apex/FileUpload');
        //page.setRedirect(true);
        return page;   
	}
	
	static testmethod void testFileUpload() {
		FileUpload fu = new FileUpload();
		System.assert(!fu.hasImage);
		
		// Blank upload just bounces page.
		System.assert(fu.doUpload() == new PageReference('/apex/FileUpload'));
		
		fu.document.Name = 'test1';
		fu.document.Body = Blob.valueOf('test1'); 
		fu.doUpload();
		System.assert(fu.hasImage);
	}
	
}