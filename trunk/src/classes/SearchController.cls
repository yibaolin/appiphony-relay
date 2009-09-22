public with sharing class SearchController {

	public List<Entry__c> entryList { get; set; }
	public Integer count { get; set; }
	public String errorMessage {get; set; }
	
	public String query { get; set; }
	
	public SearchController() {
		System.debug('*****: ' + System.currentPageReference().getParameters());
		
		// Vars.
		entryList = new List<Entry__c>();
		errorMessage = '';

		// Check the state data.
		query = System.currentPageReference().getParameters().get('q');
		if (query == null || query == '' || query.length() < 4) {
			// TODO no query to display. Reroute.	
			count = 0;
			if (query == null || query == '') {
				errorMessage = 'Query cannot be blank.';
			} else {
				errorMessage = 'Query must be more than 3 characters long.';
			}
						
		} else {
			// TODO the query is "contaminated". We need to filter out non-alphanumeric characters.
			// We need to filter out "KEYWORDS" such as SELECT and quotes.

			query = '*' + query + '*';

			// Setting up the entries that will be displayed in main body. 
			// Could we use a find?('*' +   + '*')
			List<List<SObject>> searchList = [FIND :query IN ALL FIELDS RETURNING relay__Entry__c (Id, Name, Blog__c, CreatedById, cMonth__c, Alias__c, Abstract__c, Content__c, Published__c, Published_Date__c WHERE Published__c = 'Published' ORDER BY Published_Date__c DESC) ];
			System.debug('*****: ' + searchList);
			// Iterate through the list of the objects...
			// for size of searchList, get the list of Entries.
			
			for (Integer j = 0; j < searchList.size(); j++) {
				List<SObject> entries = searchList[j];
				for (Integer i = 0; i < entries.size(); i++) {
					entryList.add((Entry__c) entries[i]); // Add entries to the list 
				}				
			}
			
			count = entryList.size();
		}
	}
	
	static testmethod void testSearchController() {
		// Create a blog.
		Blog__c blog1;
		try {
			blog1 = [SELECT id FROM Blog__c LIMIT 1];
		}
		catch (Exception e) {
			blog1 = new Blog__c();
			blog1.Allow_Comments__c = true;
			blog1.Default__c = true;
			blog1.Entries_to_Display__c = 10;
			blog1.Name = 'Blog 1';
			
			insert blog1;
		}
		// Add a few entries.
		Entry__c entry1 = new Entry__c();
		entry1.Blog__c = blog1.Id;
		entry1.Published__c = 'Published';
		entry1.Published_Date__c = Datetime.now();
		entry1.Content__c = 'makumozo';
		entry1.Name = 'Entry 1';

		insert entry1;
		
		System.debug('*************: ' + entry1.id);
		
		// Call the page with a blank param to just trigger the error.
		Pagereference page1 = Page.SiteSearch;
		page1.getParameters().put('q', '');
		Test.setCurrentPageReference(page1);
		SearchController sc1 = new SearchController();
		System.assert(sc1.errorMessage == 'Query cannot be blank.');
		
		// Query by year
		page1.getParameters().put('q', '123');
		Test.setCurrentPageReference(page1);
		SearchController sc2 = new SearchController();
		System.assert(sc2.errorMessage == 'Query must be more than 3 characters long.');
		
		// Query by year and month
		page1.getParameters().put('q', 'maku');
		Test.setCurrentPageReference(page1);
		SearchController sc3 = new SearchController();
		System.debug('***************: ' + sc3.query);
		System.debug('***************: ' + sc3.count);
		System.debug('***************: ' + sc3.entryList);
	}
	
}