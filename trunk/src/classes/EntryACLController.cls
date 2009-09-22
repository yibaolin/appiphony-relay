/************************************************************
	EntryACLController allows users linked to a blog to 
	edit, add or delete posts.
************************************************************/
public with Sharing class EntryACLController {
	public boolean isAllowed { get; set; }
	
	public EntryACLController(ApexPages.StandardController c) {
		isAllowed = false;
	
		Entry__c entry = (Entry__c) c.getRecord();

		if (entry.id != null) {
			entry = [SELECT id, Blog__c FROM Entry__c WHERE id = :entry.Id LIMIT 1];
		}

		Blog__c b = [SELECT id FROM Blog__c WHERE id= :entry.Blog__c LIMIT 1];
		
		// UserProfile can return more than one item for a UserId
		List<UserProfile__c> profileList = [SELECT id FROM UserProfile__c WHERE ownerid= :UserInfo.getUserId()];
		
		// Find all the ACL's that are assoc. to the blog. We'll lookup profile by users
		List<ACL__c> acl = [SELECT id, Profile__c FROM ACL__c WHERE Blog__c = :b.id];
	
		// If you find an acl for any owner profile, make it true and break.
		if (acl != null && profileList != null) {
			for (ACL__c loopacl : acl) {
				for (UserProfile__c loopProfile : profileList) {
					if (loopacl.Profile__c == loopProfile.id) {
						isAllowed = true;
						break;
					}
				}
			}
		}
		 
		if (!isAllowed) {
		    ApexPages.Message pMessage = new ApexPages.Message(ApexPages.Severity.FATAL,'You are not allowed to add/edit content on this blog.');
	 		ApexPages.addMessage(pMessage);
		}
	}

	static testmethod void testEntryAcl() {
		// Create a blog.
		Blog__c blog1;
		try {
			blog1 = [SELECT id,Allow_Comments__c,Entries_to_Display__c,Name,Default__c FROM Blog__c WHERE Default__c = true LIMIT 1];
		} catch (Exception e) {
			blog1 = new Blog__c();
			blog1.Allow_Comments__c = true;
			blog1.Default__c = true;
			blog1.Entries_to_Display__c = 10;
			blog1.Name = 'Blog 1';
			insert blog1;
		}

		System.assert(blog1.id != null); // Assert that blog has and id.
		

		// Add a few entries.
		Entry__c entry1 = new Entry__c();
		entry1.Blog__c = blog1.Id;
		entry1.Published__c = 'Published';
		entry1.Content__c = 'test';
		entry1.Name = 'Entry 1';

		insert entry1;
		System.assert(entry1.id != null); // Assert that entry has and id.
		
		// We need to create a profile 
    	UserProfile__c uP;
    	try {
	    	Id userId = [SELECT id FROM UserProfile__c WHERE OwnerId = :Userinfo.getUserId()].id;
    	
    	} catch (Exception e) {
			uP = new UserProfile__c();
			uP.Name = 'testProfile1';
			uP.Profile_Text__c = 'test';
			up.OwnerId = System.Userinfo.getUserId();				
			insert uP;
    	
    	} finally {
    		uP = [SELECT Id,Name,Profile_Text__c, OwnerId FROM UserProfile__c WHERE OwnerId = :Userinfo.getUserId()];
    	}
		System.assert(uP.id != null); // Assert that entry has and id.

		// we need an acl
		ACL__c acl = new ACL__c();
		acl.Blog__c = blog1.Id;
		acl.Profile__c = uP.Id; 
				
		insert acl;
		System.assert(acl.id != null); // Assert that entry has and id.
				
		// Now try to edit/modify the entry.
		Pagereference page1 = Page.EntryEdit;
		page1.getParameters().put('id', entry1.id);
		Test.setCurrentPageReference(page1);
		EntryACLController eac3 = new EntryACLController(new ApexPages.StandardController(entry1));
		System.assert(eac3.isAllowed);
		
	}

}