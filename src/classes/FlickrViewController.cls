public with sharing class FlickrViewController {
public String status {get; set;}
public String username {get; set;}
private static String api_key = 'b08b3ee9e33a7d4c3d317bf2e2a15c9b';
private static String secret = 'ebcb533ca7b6d3b8';
private static String REST = 'http://api.flickr.com/services/rest/';
private static String Upload = 'http://api.flickr.com/services/upload/';
private static String Replace = 'http://api.flickr.com/services/replace/';
private String req;
public String response;
public String parsed_response;
public static Boolean cache = false;
public String cache_db = null;
public String cache_table = null;
public String cache_dir = null;
public String cache_expire = null;
private Boolean die_on_error;
public String error_code;
public String error_msg;
private String token;
public String service;
public String format;

public FlickrViewController() {
	this.service = 'flickr';
	//this.format  = 'json';
	status = auth_getFrob();


}
	
public String apiRequest (String command) {
	MAP<string, string> defArgs = new MAP<string, string>();
	defArgs.put('','');
	return apiRequest(command, defArgs);
}	
	
public String apiRequest (string command, MAP<string, string> args) {
		if (!command.contains(service + '.')) {
			command = service + '.' + command;
		}
		args.put('method', command);
		//args.put('format', format);
		args.put('api_key', api_key);
		String argStr = '';
		String auth_sig = '';
		for (string key : args.keySet() ) {
			if (key != '') {
			argStr += key + '=' + args.get(key) + '&';
			auth_sig += key + args.get(key);
			}
		}
		
		argStr += 'api_sig=' +  EncodingUtil.convertToHex((Crypto.generateDigest('MD5', Blob.valueOf(secret + auth_sig))));
		
		HttpResponse req = makeRequest(REST, argStr);
		//return (secret + auth_sig);
		return parseResponse(req.getBody());
		//return argStr + ' - ' + secret + auth_sig;
}

public String parseResponse(String body) {
	
	
	
	
	
	//String r;
	//r = node.get('rsp.frob');
//	System.debug(node);
	return '';
}


public string auth_getFrob () {
		
		return apiRequest('flickr.auth.getFrob');
		//return parsed_response ? parsed_response['frob'] : false;
	}


public void postTest() {
	
}

public static HttpResponse makeRequest(string url, string body)  {
    	  HttpRequest req = new HttpRequest();   
          HttpResponse response = null;
          req.setEndpoint( url );
          req.setMethod('POST');
          req.setBody (body);
          try {
            Http http = new Http();
            response = http.send(req);

           
          } catch( System.Exception e) {
             System.debug('ERROR: '+ e);
          }
          return response;
        }	

/* TEST CLASS */

static testmethod void testConstruct() {
	FlickrViewController f = new FlickrViewController();
}
}