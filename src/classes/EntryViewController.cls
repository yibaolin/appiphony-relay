/************************************************************
	EntryViewController controls the view of entires on the
	sites pages
************************************************************/
public with Sharing class EntryViewController {

	// These variables are similar to the BlogViewController - check the comments there for more info.
	public Entry__c pageEntry { get; set; }
	public List<Entry__c> recentEntries { get; set; }
	public Blog__c pageBlog { get; set; }
	public List<BlogLink__c> blogRoll { get; set; }
	public List<Blog__c> blogList { get; set; }
	public List<cMonth__c> monthlyId { get; set; }
	public String captchaMsg { get; set; }
	public String exp { get; set; } // The statedata for the expandable side tree
	public Comment__c dummy { get; set; }
	public List<Comment__c> entryComments { get; set; } // The comments assoc with this entry.
	public Integer numComments {get; set;}
	public String plural {get; set;}
	
	public EntryViewController() {
		captchaMsg = '';
		
		Id id = System.currentPageReference().getParameters().get('id');

		exp = '';
		exp = System.currentPageReference().getParameters().get('exp');
		
		// Get the entry associated...
		pageEntry = [SELECT Id, Name, Alias__c, Blog__c, Close_Comment__c, CreatedById, Abstract__c, Content__c, Published__c, Published_Date__c FROM Entry__c WHERE Published__c = 'Published' AND Id = :id];
		
		// Get the comments associated...
		entryComments = [SELECT Id, Body__c, Email__c, CreatedDate FROM Comment__c WHERE Entry__c = :pageEntry.id ORDER BY CreatedDate ASC];
		numComments = entryComments.size();
		
		if (numComments == 1) {
			plural = '';
		} else {
			plural = 's';
		}
		
		// Look up the blog that this entry is associated with.
		pageBlog = [SELECT Id, RSS_Path__c, Name, Sidebar__c, Allow_Comments__c, Entries_to_display__c from Blog__c where Id = :pageEntry.Blog__c];
		
		// Look up the Additional recent cases.
		recentEntries = [SELECT Id, Name, Alias__c, CreatedById, Abstract__c, Content__c, Published__c, Published_Date__c FROM Entry__c WHERE Published__c = 'Published' AND Blog__c = :pageBlog.id ORDER BY Published_Date__c DESC limit :pageBlog.Entries_to_display__c.intValue()];			
		blogRoll = [SELECT Name, URL__c, Blog__c, Number__c FROM BlogLink__c WHERE Blog__c = :pageBlog.Id ORDER BY Number__c ASC ];		

		monthlyId = [SELECT Id, Name, cYear__c, CreatedDate, Year_Name__c, Display_Name__c FROM cMonth__c WHERE cYear__r.Blog__c = :pageEntry.Blog__c ORDER BY Published_Date__c DESC ]; 
	
		dummy = new Comment__c();
	}
	
	
	public PageReference postComment() {
		String headers='';
		String captchaChallenge;
		String captchaResponse;
        MAP<string, string> hdrs = ApexPages.CurrentPage().getParameters();
        for (string key : hdrs.keySet() ) {
            if (key == 'recaptcha_challenge_field') captchaChallenge = hdrs.get(key);
            if (key == 'recaptcha_response_field') captchaResponse = hdrs.get(key);
        }
		if (!captchaController.checkCaptcha(captchaChallenge, captchaResponse)) {
            captchaMsg = 'Invalid Captcha: Please Try Again';
          	
			return null;
		}
		
		// Take the input, and post a new comment
		dummy.Entry__c = pageEntry.Id;
		insert dummy;
		
		PageReference pref = Page.SiteEntryView;
		pref.getParameters().put('id', pageEntry.id);
		pref.getParameters().put('ck', String.valueOf(Datetime.now().getTime()));
		pref.setRedirect(true);
		
		return pref; 
	}

	static testmethod void testEntryViewController() {
		// Create a blog.
		
		Blog__c blog1;
		try {
			blog1 = [SELECT id FROM Blog__c LIMIT 1];
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

		
		// Call the page with a param.
		Pagereference page1 = Page.SiteEntryView;
		page1.getParameters().put('id', entry1.id);
		Test.setCurrentPageReference(page1);
		EntryViewController evc3 = new EntryViewController();
		System.assert(evc3.pageEntry.id == entry1.id);
		
		evc3.dummy.Sentinel__c = '4';
		evc3.dummy.Body__c = 'test';
		evc3.dummy.Email__c = 'test@appiphony.com';
		PageReference commentReturn = evc3.postComment();
		System.assert(commentReturn == null); // will be null because callout not allowed
	}
}