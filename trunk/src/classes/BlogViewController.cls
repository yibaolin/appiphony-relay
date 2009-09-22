/************************************************************
	BlogViewController - Controls the data and the view
	of blogs and entries on the sites pages.
************************************************************/
public with Sharing class BlogViewController {
	
	public List<Entry__c> recentEntries { get; set; } // just a list of tiltes
	public List<Entry__c> entryList { get; set; } // The full text of entires we'll display.
	public Blog__c pageBlog { get; set; } // the blog that we're referencing.
	public List<Blog__c> blogList { get; set; } // a list of other blogs (if any)
	public List<cMonth__c> monthlyId { get; set; } 
	public List<BlogLink__c> blogRoll { get; set; } // links/other blogs
	public String exp { get; set; } // The url date for the expandable side tree
	public Boolean render {get; set; } 
	public String errorMsg {get; set; }

	// Constructor.
	public BlogViewController() {
		// Vars.
		errorMsg = '';
		render = true;
		cYear__c yearTable = null; // If a specific year queried
		cMonth__c monthTable = null; // If a specific month queried
		cMonth__c[] completeMonths; // Will be used in an "IN" query.

		// Check the url and grab parameters
		// the ID is the blog id... 
		Id id = System.currentPageReference().getParameters().get('id');

		// We can filter by specific year/month/etc.
		String year = System.currentPageReference().getParameters().get('year');
		String month = System.currentPageReference().getParameters().get('month');
		
		// Controls if the accordion archive is or isn't expanded into the full tree.
		exp = '';
		exp = System.currentPageReference().getParameters().get('exp');
	
		// Get all blogs. THIS HAS MOVED TO THE SIDEBAR CONTROLLER!
		// blogList = [SELECT Id, Name FROM Blog__c]; // query to find all blogs.
		
		// If month is not null, but the year is null, set the month to null.
		if (month != null && year == null) {
			// Forget the date stuff. Disregard month.
			month = null;	
		}

		try {
			if (id == null) { 		
				pageBlog = [SELECT CreatedDate, Id, Name, RSS_Path__c, Allow_Comments__c, Sidebar__c, Entries_to_display__c, Default__c FROM Blog__c WHERE Default__c = true ORDER BY CreatedDate DESC LIMIT 1 ];
			} else {
				pageBlog = [SELECT Id, Name, RSS_Path__c, Allow_Comments__c, Sidebar__c, Entries_to_display__c FROM Blog__c WHERE Id = :id ];
			}
		} catch (Exception e) {
			// No blog found, toss an exception.
			errorMsg = 'No Default Blog Selected';
			render = false;
			return;
			//throw e;
		}
		
		// Setting up the "dates" that we'll use to query for entries below.
		if (year != null) { 
			yearTable = [SELECT Name, Id, Blog__c FROM cYear__c WHERE Blog__c = :pageBlog.id AND Name = :year]; 
			if (month != null) {
				monthTable = [SELECT Name, Id, cYear__c FROM cMonth__c WHERE cYear__c = :yearTable.id AND Name = :month];
			} else {
				completeMonths = [SELECT Name, Id, cYear__c FROM cMonth__c WHERE cYear__c = :yearTable.id];
			}	
		}
		
		// Setting up the entries that will be displayed in main body. 
		if (year != null && month != null) {
			//Use the month table to query for entries.
			entryList = [SELECT Id, Name, Blog__c, Alias__c, CreatedById, cMonth__c, Abstract__c, Content__c, Published__c, Published_Date__c FROM Entry__c WHERE Published__c = 'Published' AND Blog__c = :pageBlog.id AND cMonth__c = :monthTable.id ORDER BY Published_Date__c DESC ];			
		} else if (year != null) {
			// Use all months via IN clause
			entryList = [SELECT Id, Name, Blog__c, Alias__c, CreatedById, Abstract__c, Content__c, Published__c, Published_Date__c FROM Entry__c WHERE Published__c = 'Published' AND Blog__c = :pageBlog.id AND cMonth__c IN :completeMonths ORDER BY Published_Date__c DESC ];			
		} else {
			// Query all entries
			entryList = [SELECT Id, Name, Blog__c, Alias__c, CreatedById, Abstract__c, Content__c, Published__c, Published_Date__c FROM Entry__c WHERE Published__c = 'Published' AND Blog__c = :pageBlog.id ORDER BY Published_Date__c DESC limit :pageBlog.Entries_to_display__c.intValue() ];
		}
		
		// We skip the display or the queries in the main body. Oh well.
		
		// Find the recent entries to display on the side bar.
		recentEntries = [SELECT Id, Name, Blog__c, Alias__c, CreatedById, Abstract__c, Content__c, Published__c, Published_Date__c FROM Entry__c WHERE Published__c = 'Published' AND Blog__c = :pageBlog.id ORDER BY Published_Date__c DESC limit :pageBlog.Entries_to_display__c.intValue() ];
		blogRoll = [SELECT Name, URL__c, Blog__c, Number__c FROM BlogLink__c WHERE Blog__c = :pageBlog.Id ORDER BY Number__c ASC ];		
		
		// Set the monthlyList for valid months/years to display for Archives (used in JS tree on pages)
		//Get the valid months by querying the years related list by blogID. 
		// The JS that runs this is fairly complex - we pass in the months and use some script to read 
		// In a <UL> table from the Blog__c.Sidebar to display as a tree.
		monthlyId = [SELECT Id, Name, cYear__c, Year_Name__c, Display_Name__c, Published_Date__c FROM cMonth__c WHERE cYear__r.Blog__c = :pageBlog.id ORDER BY Published_Date__c DESC ]; 
	}

	static testmethod void testBlogViewController() {
		// Create a blog or use the default.
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


		// This will get the default blog, which is blog1 if there are no other blogs!
		System.currentPageReference().getParameters().put('id', blog1.id);
		BlogViewController bvc = new BlogViewController();
		System.assert(bvc.pageBlog.Id == blog1.Id);
		
		// Add a few entries.
		Entry__c entry1 = new Entry__c();
		entry1.Blog__c = blog1.Id;
		entry1.Published__c = 'Published';
		entry1.Content__c = 'test';
		entry1.Name = 'Entry 1';

		insert entry1;
		System.assert(entry1.id != null); // Assert that entry has and id.

		// Ensure that the Blog1 sidebar is not null now.
		BlogViewController bvc2 = new BlogViewController();
		System.assert(bvc2.pageBlog.Sidebar__c != null);
		
		// Call the page with a param.
		Pagereference page1 = Page.SiteBlogView;
		page1.getParameters().put('id', blog1.id);
		Test.setCurrentPageReference(page1);
		BlogViewController bvc3 = new BlogViewController();
		System.assert(bvc3.pageBlog.Id == blog1.Id);
		
		// Query by year
		page1.getParameters().put('year', String.valueOf(date.today().year()));
		Test.setCurrentPageReference(page1);
		BlogViewController bvc4 = new BlogViewController();
		System.assert(bvc4.entryList[0].id == entry1.Id);
		
		// Query by year and month
		page1.getParameters().put('month', BlogUtils.monthNameByMonthNumber(date.today().month()));
		Test.setCurrentPageReference(page1);
		BlogViewController bvc5 = new BlogViewController();
		System.assert(bvc5.entryList[0].id == entry1.Id);
	
	}

	
}