public with sharing class UserProfileViewController {

	public UserProfile__c up {get; set;}
	public User u {get; set;}
	public String id {get; set;}
	public String pImageUrl {get; set;}
	public String profileText {get; set;}
	public String profileTitle {get; set;}

	public UserProfileViewController() { 

		// Get the ID from the URL The Id corresponds to a user Id.
		id = System.currentPageReference().getParameters().get('id');  

		if (id == null || id == '') {
			ApexPages.Message pMessage = new ApexPages.Message(ApexPages.Severity.FATAL,'Invalid Profile ID');
	 		ApexPages.addMessage(pMessage);
			return;
		}
		

		try { // Query for he profile. If none, then create a blank. 
			u = [SELECT Name, firstname, lastname, id, alias FROM User WHERE id= :id];
			up = [SELECT id, ownerid, Profile_Text__c, Title__c, Name, Profile_Image_Url__c FROM UserProfile__c WHERE ownerid= :u.id LIMIT 1];
			profileText = up.Profile_Text__c;
			profileTitle = up.Title__c;
			if (up.Profile_Image_Url__c != null || up.Profile_Image_Url__c != '') {
				pImageUrl = EncodingUtil.urlDecode(up.Profile_Image_Url__c, '%xy');
			}

		} catch (Exception e) {
			// If this blow chunks, there isn't a profile...
			u = new User();
			up = new UserProfile__c();
			pImageUrl = null;
		}				
	}
	
	static testmethod void TestUserProfile() {
    	// Have to create a profile
    	UserProfile__c uP;
    	try {
	    	Id curUser = [SELECT id FROM UserProfile__c WHERE OwnerId = :Userinfo.getUserId()].id;
    	}
    	catch (Exception e) {
		uP = new UserProfile__c();
		uP.Name = 'testProfile1';
		uP.Profile_Text__c = 'test';
		up.OwnerId = System.Userinfo.getUserId();				
		insert uP;
    	}
    	finally {
    		uP = [SELECT Id,Name,Profile_Text__c, OwnerId FROM UserProfile__c WHERE OwnerId = :Userinfo.getUserId()];
    	}


		UserProfileViewController upc = new UserProfileViewController();
		
		// Test with bad id.
		Pagereference page1 = Page.SiteProfileView;
		page1.getParameters().put('id', 'mickeymouse');
		Test.setCurrentPageReference(page1);
		UserProfileViewController upc2 = new UserProfileViewController();
		
		// test with an id.
		page1.getParameters().put('id', System.Userinfo.getUserId());
		Test.setCurrentPageReference(page1);
		UserProfileViewController upc3 = new UserProfileViewController();
		
				
	}
	
}