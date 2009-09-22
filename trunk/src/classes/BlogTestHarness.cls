/************************************************************
	BlogTestHarness simply tests the comment and blog
	triggers.
************************************************************/
public class BlogTestHarness {

	static testmethod void makeBlogEntriesComments() {
		
		Blog__c blog1; // the blog we'll be adding items to. If there is a default blog, then use it, if not, create one.
		try {
			blog1 = [SELECT id, Default__c FROM Blog__c WHERE Default__c = true LIMIT 1];

		} catch (Exception e) {
			blog1 = new Blog__c();
			blog1.Allow_Comments__c = true;
			blog1.Default__c = true;
			blog1.Entries_to_Display__c = 10;
			blog1.Name = 'Blog Test 1';
			insert blog1;
		}

		System.assert(blog1.id != null); // Assert that blog has and id.
		

		List<Entry__c> entryList = new List<Entry__c>(); // A list of dummy entries.
		Entry__c entry1 = new Entry__c();

		for (Integer i=0; i < 100; i++) { // had to kick it to 100, since adding 200 would result in a over the limit issue...
			entry1 = new Entry__c();
			entry1.Blog__c = blog1.Id;
			entry1.Published__c = 'Published';
			entry1.Content__c = 'test';
			entry1.Name = 'Entry ' + i;
			entry1.Published_Date__c = Datetime.now();
			entryList.add(entry1);
		}

		insert entryList; // Insert the entries.

		// Have some way that the entries actually went through.
		for (Entry__c loopEntry : entryList) {
			System.assert(loopEntry.Id != null);
		}
				

		List<Comment__c> commentList = new List<Comment__c>(); // A list of comments that we'll add.	
		Comment__c comment = new Comment__c();
		for(Integer j=0; j < entryList.size(); j++) {
			comment = new Comment__c();
			//comment.Entry__c = entryList[j].Id;
			comment.Body__c = 'TESTING123';
			comment.Email__c = 'bob@bob.com';
			comment.Sentinel__c = '4';
			commentList.add(comment);
		}

		insert commentList;

		// Have some way that the entries actually went through.
		for (Comment__c loopComment : commentList) {
			System.assert(loopComment.Id != null);
		}

		delete blog1; // cascade a delete.	
		
	}

}