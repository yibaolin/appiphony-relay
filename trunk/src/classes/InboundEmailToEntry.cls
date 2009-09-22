/**
 * Email services are automated processes that use Apex classes
 * to process the contents, headers, and attachments of inbound
 * email.
 */
global class InboundEmailToEntry implements Messaging.InboundEmailHandler {

    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();

		// Grab the user that we'll use to process this email.
		try {

				String title = email.Subject;
				String body = email.plainTextBody; // Use the plain text to create a body.
		
				//Iterate over attachment and create docs that are public.
				List<Id> docIdsList = new List<Id>();
				if (email.binaryAttachments != null && email.binaryAttachments.size() > 0) {
					for (Integer i = 0; i < email.binaryAttachments.size(); i++) {
						Document doc = new Document();
						doc.Body = email.binaryAttachments[i].body;
						doc.IsPublic = true;
						doc.Name = email.binaryAttachments[i].fileName;
						doc.FolderId = Userinfo.getUserId();
						insert doc;
						docIdsList.add(doc.id);

/*						
						StaticResource doc = new StaticResource();
						doc.Body = email.binaryAttachments[i].body;
						doc.CacheControl = 'Public';
						doc.Name = email.binaryAttachments[i].fileName;
						insert doc;
						docIdsList.add(doc.id);
*/
					}
				}
		
				// Get the organization Id.
				Id orgId = [SELECT Id FROM Organization].Id;
		
				Entry__c emailEntry = new Entry__c();
				emailEntry.Blog__c = [SELECT Id, Default__c FROM Blog__c WHERE Default__c = true LIMIT 1].Id;
				emailEntry.Published__c = 'Published';
				emailEntry.Name = title;
				emailEntry.Content__c = body;
				for (Integer i = 0; i < docIdsList.size(); i++) {
					// Just use a relative path. 
					emailEntry.Content__c += '<br/><img src="/servlet/servlet.ImageServer?id=' + docIdsList[i] + '&oid=' + orgId + '">';
				}
					
				insert emailEntry;

		} catch (Exception e) {
			result.success = false;
			result.message = 'An error occured. Not processed.';
		}

        return result;
    }
    
    public static testMethod void testInboundEmailToEntry(){
        
        // Create a new email, envelope object and Attachment
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        
        email.subject = 'test';
        email.plainTextBody = 'Hello, this a test email body. for testing purposes only. Bye';
        Messaging.InboundEmail.BinaryAttachment attach1 = new Messaging.InboundEmail.BinaryAttachment();
        attach1.fileName = 'test.gif';
        attach1.body = Blob.valueOf('Argh matey');
        email.binaryAttachments = new List<Messaging.InboundEmail.BinaryAttachment>();
        email.binaryAttachments.add(attach1);
        env.fromAddress = 'test@appiphony.com';

        // setup controller object
        InboundEmailToEntry catcher = new InboundEmailToEntry();
        catcher.handleInboundEmail(email, env);
    
    }
    
}