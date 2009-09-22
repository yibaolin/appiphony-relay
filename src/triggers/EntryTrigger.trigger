/* The EntryTrigger fires on both before and afters for updates and inserts.
The before trigger associates the entry with the correct dates.
The after trigger rewrites hte sidesbar of the blog - no need to dynamically recreate it every page load.
*/

// TODO: Write test cases for this trigger.

trigger EntryTrigger on Entry__c (before insert, before update, after insert, after update, after delete) {

    if (Trigger.isBefore) {

		// Generate a list of all the year and months so far.
	    List<Id> blogIds = new List<Id>();
	    for (Integer j = 0; j < Trigger.new.size(); j++ ) {
	        Entry__c entry = Trigger.new[j];
	    	if (entry.Published__c == 'Published' && entry.Blog__c != null) {
				blogIds.add(entry.Blog__c);
	    	}
	    }	
	
		Map<Id, cYear__c> yearMap = new Map<Id, cYear__c>([SELECT Id, Name, BLog__c FROM cYear__c WHERE Blog__c IN :blogIds]);  
		Map<Id, cMonth__c> monthMap = new Map<Id, cMonth__c>([SELECT Id, Name, cYear__c FROM cMonth__c WHERE cYear__c IN :yearMap.keySet()]);  

		// Lookup the alias.
		String aliasName = UserInfo.getUserId();

		List<Integer> withoutMonth = new List<Integer>();
		// Find the entries that don't have months associated with 'em...
        for (Integer j = 0; j < Trigger.new.size(); j++ ) {
            Entry__c entry = Trigger.new[j];
        	if (entry.Published__c == 'Published' && entry.cMonth__c == null) {
        		// If an entry has no month, then push its index to a list
        		withoutMonth.add(j);
        	}
        }

		List<cYear__c> insertYears = new List<cYear__c>();
		Map<Integer, Integer> insertYearsMonthsLinkage = new Map<Integer, Integer>();

		List<cMonth__c> insertMonths = new List<cMonth__c>();
		Map<Integer, Integer> insertMonthsEntryLinkage = new Map<Integer, Integer>();
		

        for (Integer j : withoutMonth) {

			// Check if the status is published -- If not published, we won't do anything. 
			if (Trigger.new[j].Published__c != null && Trigger.new[j].Published__c == 'Published') {
				// Find the blog this entry is associated with
				Id blogId = Trigger.new[j].Blog__c;

	
				// The entry is marked published. Check that the published date
				// is populated. If not, then set the time now to the published date.
				if (Trigger.new[j].Published_Date__c == null) {
					Trigger.new[j].Published_Date__c = Datetime.now();
				}
				
				if (Trigger.new[j].Alias__c == null || Trigger.new[j].Alias__c == '') {
					Trigger.new[j].Alias__c = aliasName;
				}
				
				// Since we're ensured that we've got a pubdate, deconstruct it and get the year, month, etc.
				Integer yearDate = Trigger.new[j].Published_Date__c.year();
				String monthName = BlogUtils.monthNameByMonthNumber(Trigger.new[j].Published_Date__c.month());
				
				// Now we can move on to examine the dates associated with this entry.	
				cYear__c yearId = null; 			
				cMonth__c monthId = null;		
				
				// Get a year that is associated with this blog.
				for (cYear__c loopYear : yearMap.values()) {
					if (loopYear.Name == String.valueOf(yearDate) && (loopYear.Blog__c != null && loopYear.Blog__c == blogId)) { 
						yearId = loopYear;
						System.debug('****************** ' + yearId);
						break;
					}
				}
				
				// Get a month that is associate with this year.
				if (yearId != null) {
					for (cMonth__c loopMonth : monthMap.values()) {
						if (loopMonth.Name == monthName && (loopMonth.cYear__c != null && loopMonth.cYear__c == yearId.Id)) {
							monthId = loopMonth;
							// We've got a month, so we've got a year. Just tie those to the entry.
							Trigger.new[j].cMonth__c = monthId.Id;
							System.debug('****************** ' + monthId);
							break;
						}
					}
					
				} else { // The yearId is null, so we need to create it.
					// Add the year to a year map.
					// If there is no year, then we also have to add a month.
					cYear__c newYear = null;
					for (Integer i = 0; i < insertYears.size(); i++) {
						 cYear__c listYear = insertYears[i];
						if (listYear.Name == String.valueOf(yearDate) && listYear.Blog__c == Trigger.new[j].Blog__c) {
							insertYearsMonthsLinkage.put(j, i); //
							newYear = insertYears[i];
							break;
						}
					}
					
					if (newYear == null) {
						newYear = new cYear__c();
						newYear.Name = String.valueOf(yearDate);
						newYear.Blog__c = Trigger.new[j].Blog__c;
						insertYearsMonthsLinkage.put(j, insertYears.size()); //
						insertYears.add(newYear); // put the years into a list
					}
				}
				
				
				// If month is null, then there should be a year already.
				if (monthId == null) {

					// There may be a month in the create list, so we should use that one.
					cMonth__c newMonth = null;
					for (Integer i = 0; i < insertMonths.size(); i++) {
						cMonth__c listMonth = insertMonths[i];
						System.debug('**********************' + insertMonths.size());
						System.debug('**********************' + insertMonths);
						
						if (listMonth.Name == monthName && (listMonth.Blog__c != null && listMonth.Blog__c == Trigger.new[j].Blog__c) ) {
							insertMonthsEntryLinkage.put(j, i); 
							newMonth = insertMonths[i];
							break;
						}
					}

					if (newMonth == null) {
						newMonth = new cMonth__c();
						newMonth.Name = monthName;
						newMonth.Blog__c = Trigger.new[j].Blog__c;
						if (yearId != null) {
							newMonth.cYear__c = yearId.id;
							newMonth.Year_Name__c = yearId.Name;
							newMonth.Display_Name__c = monthName + ' ' + yearId.Name;
						}
						newMonth.Published_Date__c = Datetime.now();
						insertMonthsEntryLinkage.put(j, insertMonths.size());
						insertMonths.add(newMonth);
						System.debug('***********************' + newMonth);
					}
					
				} 
			}				
		}
		
		// Insert years.
		if (insertYears.size() > 0) {
			insert insertYears;
		}

		System.debug('***********************map: ' + insertYearsMonthsLinkage);
		System.debug('***********************list: ' + insertYears);

		System.debug('***********************map: ' + insertMonthsEntryLinkage);
		System.debug('***********************list: ' + insertMonths);

		// Insert months. We must create the association between the years and months from the linkage.
		if (insertMonths.size() > 0) {
			for (Integer j = 0 ; j < Trigger.new.size(); j++) {
				if (insertYears.size() > 0) {
					Integer linkageIndex = insertYearsMonthsLinkage.get(j);
					if (linkageIndex != null) {
						cYear__c yearJ = insertYears.get(linkageIndex);
						if (yearJ != null) {
							cMonth__c monthJ = insertMonths.get(insertMonthsEntryLinkage.get(j));
							monthJ.cYear__c = yearJ.id;
							monthJ.Year_Name__c = yearJ.Name;
							monthJ.Display_Name__c = monthJ.Name + ' ' + yearJ.Name;
							insertMonths.set(insertMonthsEntryLinkage.get(j), monthJ);
						}
					}
				}
			}

			System.debug('***********************listinput: ' + insertMonths);
			insert insertMonths;
		}
	
		System.debug('***************** ' + Trigger.new);
		// Associate months to entries.
		for (Integer j = 0 ; j < Trigger.new.size(); j++) {
			if (Trigger.new[j].cMonth__c == null) {
				Integer linkageIndex = insertMonthsEntryLinkage.get(j); // Grab the linkage 
				if (linkageIndex != null && insertMonths.get(linkageIndex) != null) {
					Trigger.new[j].cMonth__c = insertMonths.get(insertMonthsEntryLinkage.get(j)).id;
				}
			}
		}
    }
    
    if (Trigger.isAfter) {
    	// Since we've updated an item, we rewrite the HTML sidebar that lists entries on a blog object.
    	// Note that since this runs after the list, we actually generate a current list - and handle deleted items in the process.
		
		// Find the Ids for all the blogs from the Entries.
//		List<Id> blogIds = new List<Id>();
/*
		Map<Id, List<Entry__c>> blogEntryMap = new Map<Id, List<Entry__c>>();		
		for (Integer i = 0; i < Trigger.new.size(); i++ ) {
			Entry__c entry = Trigger.new[i];
			blogIds.add(entry.Blog__c);

			List<Entry__c> entryList = blogEntryMap.get(entry.Blog__c);
			if (entryList == null) {
				entryList = new List<Entry__c>();
				entryList.add(entry);
				blogEntryMap.put(entry.Blog__c, entryList);
			} else {
				entryList.add(entry);
				blogEntryMap.put(entry.Blog__c, entryList);
			}
		}
*/
		// We now have entries set up by blog is.

		// Cascasded queries.
		// TODO: you could throw this query away because the entry alreay has Blog__c associated.
		// It'd make sense to order the entries by Blog__c and make a map of a list of entries by Blog Id.
		// Map<BlogId, List<entries>>
		Map<Id, Blog__c> blogMap = new Map<Id, Blog__c>([SELECT Id, Name, Sidebar__c FROM Blog__c]);
		List<Blog__c> blogs = blogMap.values();
		List<Id> blogIds = new List<Id>();
		for (Integer i = 0; i < blogs.size(); i++) {
			blogIds.add(blogs[i].Id);
		}
		
		
		// Find the years assoc. with Blogs. - Probably 1-10 years objects. --> That'd be ~100 items
		Map<Id, cYear__c> yearMap = new Map<Id, cYear__c>([SELECT Id, Name, Blog__c FROM cYear__c WHERE Blog__c IN :blogMap.keySet() ORDER BY Name DESC]);	
	
		// Find the months assoc with the Years --> For each year, a max of 12 month objects ~1200 items.
		Map<id, cMonth__c> monthMap = new Map<Id, cMonth__c>([SELECT Id, Name, cYear__c FROM cMonth__c WHERE cYear__c in :yearMap.keySet()]);

		// TODO think about this.
		// Find the entries assoc. with those months. --> could be 100 per month... LIMIT Issue.
		// Could you chunk this in groups? You know a list of lists? By Id?
		// THIS IS BAD. GET BY BLOG__C instead.
		List<Entry__c> entryList = [SELECT Name, Id, cMonth__c FROM Entry__c WHERE cMonth__c IN :monthMap.keySet() AND Published__c = 'Published' ORDER BY Published_Date__c DESC];
		
		// THe list of blogs that we'll update.
		List<Blog__c> updateBlogs = new List<Blog__c>();
		
		// No need to iterate over the list again... We've got items by blog, etc...
		for (Integer i = 0; i < blogIds.size(); i++) {
			            
			Id blogId = blogIds[i]; // This is the blog associated with this entry.
			String sidebar = ''; // We rewrite the sidebar each time.

			
			// Check for the years associated with this blog:
			List<cYear__c> yearAssocWithBlog = new List<cYear__c>();
			List<cYear__c> allYearValues = yearMap.values();
			for (Integer j = 0; j < allYearValues.size(); j++) {
				if (allYearValues[j].Blog__c == blogId) {
					yearAssocWithBlog.add(allYearValues[j]);
				}
			}
			
			// Check for the months associate with these years.
			List<cMonth__c> monthsAssocWithBlog = new List<cMonth__c>();
			List<cMonth__c> allMonthValues = monthMap.values();
			for (Integer j = 0; j < yearAssocWithBlog.size(); j++) {
				for (Integer k = 0; k < allMonthValues.size(); k++) { // check for the months associated with these years.
					if (allMonthValues[k].cYear__c == yearAssocWithBlog[j].Id) {
						monthsAssocWithBlog.add(allMonthValues[k]);
					}
				}
			}
			
			// Check the entries associated with these years.
			// The loop is a bit crufty - the entrylist is probably Much larger than month, but since the entry list is in order by date,
			// I don't want to loose that information by switching the loops.
			Boolean newHeader = true;
			for (Integer j = 0; j < monthsAssocWithBlog.size(); j++) { // Entries are in order by pub date.
				newHeader = true;

				for (Integer k = 0; k < entryList.size(); k++) { // Get ALL entries for this month...					
					if (entryList[k].cMonth__c == monthsAssocWithBlog[j].Id) {
						if (newHeader) { // Only display the header if we need to, the first time.
							sidebar += '<ul style="visibility: hidden;" id="' + monthsAssocWithBlog[j].id + '">';
							newHeader = false;
						}
						
						sidebar += '<li><a href="/SiteEntryView?id=' + entryList[k].id + '">' + entryList[k].name + '</a></li>';
					}
				}
				sidebar += '</ul>';
				
			}
			
			// Now set the sidebar with the Blog on the list.
			Blog__c ourBlog = blogMap.get(blogId);
			ourBlog.Sidebar__c = sidebar;
			updateBlogs.add(ourBlog);
		}
		
		update updateBlogs;
    }
}