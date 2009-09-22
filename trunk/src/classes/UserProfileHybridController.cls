public with sharing class UserProfileHybridController {
	
	public UserProfile__c p { get; set; }
	public Document document { get; set; }
	public Document del { get; set; }
	public string userOwner { get; set; }
	private Boolean isNew;
    
    public UserProfileHybridController(ApexPages.StandardController c)  { 
		User pOwner = new User();
		document = new Document();
        
		// Exampine the Id. populate based off of that. If no Id, then create a new profile.
		// If you've got an Id, then you've got an owner.
		Id id = System.currentPageReference().getParameters().get('id');
		if (id != null) {
	    	try {
	    		p = [SELECT OwnerId, Id, Name, Profile_Text__c, Profile_Image_Url__c, Title__c, Profile_Image_Id__c FROM UserProfile__c WHERE Id = :Id];
	    		pOwner = [SELECT FirstName, LastName, Alias FROM User WHERE Id = :p.OwnerId];
	    	}
	    	catch (Exception e) {
	    		//unable to query something just post blank
	    			p = new UserProfile__c();
					p.Profile_Image_Url__c = '';
					pOwner = [SELECT FirstName, LastName, Alias FROM User WHERE Id = :UserInfo.getUserId()];
		
	    	}
		} else {
	       	p = new UserProfile__c();
			p.Profile_Image_Url__c = '';

			pOwner = [SELECT FirstName, LastName, Alias FROM User WHERE Id = :UserInfo.getUserId()];
		}				
		userOwner = pOwner.Alias;
    }    
 
    public PageReference doSave() {
        System.debug(p);

        if (document.body != null) {
        	if (p.Profile_Image_Id__c != null) { // Remove the old image.
       			try {
       				del = [SELECT Id FROM Document WHERE Id =: p.Profile_Image_Id__c];
        			delete del;
       			} catch (Exception e) {
					del = null;
					p.Profile_Image_Id__c = null;
       			}
        	}
        }
        
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
	        insert d;
	        d.body = null;
	    
	        System.debug('@@@@@@@@ document object id: '+d.id);
	        String url = DocumentUtil.getInstance(d).getURL();
	      
	        System.debug('######## document content type: '+d.type);        
	  		
	  		p.Profile_Image_Id__c = d.id;
	  		p.Profile_Image_Url__c = url;
        }
        
  		User owner;
  		System.debug('@@@@@@@@ username: ' + owner);
  		
  		if (p.Id == null) { // Check if new or update.
  			try {
  			owner = [SELECT FirstName, LastName FROM User WHERE Id = :UserInfo.getUserId()];
  			p.Name = owner.FirstName + ' ' + owner.LastName + '\'s profile';
  			insert p;
  			}
  			catch (Exception e) {
  				System.Debug('I had an error: ' + e);
  			}
  		} else {
  			update p;
  		}
  		
        System.debug('@@@@@@@@ redirect');
        PageReference page = new PageReference('/' + p.Id);
       	page.setRedirect(true);
        return page;   
    }
    
    public PageReference doCancel() {
		// Forward you back to the profiles page default list.
		Schema.DescribeSObjectResult describeResult = UserProfile__c.SObjectType.getDescribe();
        PageReference page = new PageReference('/' + describeResult.getKeyPrefix() + '/o');
        page.setRedirect(true);
        return page;   
    }    
    
    static testmethod void testUPController() {
    	// Have to create a profile
		UserProfile__c uP;
		
		try {
			uP = [SELECT Id, Name, Profile_Text__c FROM UserProfile__c WHERE OwnerId = :UserInfo.getUserId()];
		}
		catch (Exception e) {
			uP = new UserProfile__c();
			uP.Name = 'testProfile1';
			uP.Profile_Text__c = 'test';
			insert uP;
		}
    	
    	// Try to save it with a new doc.
    	
    	// Try to cancel.
		Pagereference page1 = Page.UserProfileEdit;
		page1.getParameters().put('id', up.Id);
		Test.setCurrentPageReference(page1);
		UserProfileHybridController eac4 = new UserProfileHybridController(new ApexPages.StandardController(up));

		eac4.document.Body = Blob.valueOf('Test3');
		eac4.document.name = 'test3';
		eac4.doSave();
		
		delete up;


/*		Test.setCurrentPageReference(page1);
		UserProfileHybridController eac3 = new UserProfileHybridController(new ApexPages.StandardController(new UserProfile__c()));
    	
		eac3.doCancel();
		
		eac3.document.Body = Blob.valueOf('Test1');
		eac3.document.name = 'test1';
		eac3.doSave();
	*/	
    }
    
}