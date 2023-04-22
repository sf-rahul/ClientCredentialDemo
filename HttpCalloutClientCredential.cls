/**
*@author : Kumar Rahul
*@description : code for http callout 
*/
public class HttpCalloutClientCredential {

    
    private static final string client_id = 'XXXXXXXXXXXXXXXXXXXX';
    private static final string client_secret = 'XXXXXXXXXXXXXXXXXXXXXXXXXX';
    private static final string  grant_type = 'client_credentials';
    
    public static void  createdAccountRecord(){

         string accesstoken = getAccessToken();
        
         if(accesstoken != NULL){
           string  accountid =  createAccount(accesstoken);
         }
         
     }
    
    
//curl https://MyDomainName.my.salesforce.com/services/data/v57.0/sobjects/Account/ -H "Authorization: Bearer token" -H "Content-Type: application/json" -d "@newaccount.json"
public static  string  createAccount(String accesstoken){
       http h = new http();
       httpRequest req = new HttpRequest();
       req.setMethod('POST');
       req.setEndPoint('https://fastsf-dev-ed.my.salesforce.com/services/data/v57.0/sobjects/Account/');
       req.setHeader('Content-Type','application/json');
       req.setHeader('Authorization' , 'Bearer '+accesstoken);
       
       Account ac = new Account();
       ac.name = 'Testing http callout';
    
       req.setBody(JSON.serialize(ac));
    
      httpResponse res = h.send(req);
      if(res.getstatus() == 'CREATED' && res.getstatusCode() == 201){
         
            Response reswrapper = (Response)JSON.deserialize(res.getBody(), Response.class );
            if(resWrapper.id != NULL){
               System.debug('account created with  Id : ' + resWrapper.Id ); 
                return resWrapper.id;
            }else{
                System.debug('process failed with error : ' + resWrapper.errors);
            }
       
      }
      
    return null;
      
  }
    
    public class Response{
     String id;
     String success;
     List<String> errors;
   }
    
    //code for the access token 
    public static String getAccessToken(){
            http h = new http();
            httpRequest req = new HttpRequest();
            req.setMethod('POST');
            req.setEndPoint('https://fastsf-dev-ed.my.salesforce.com/services/oauth2/token');
            req.setheader('Content-Type','application/x-www-form-urlencoded');
            String payload = 'client_id='+EncodingUtil.urlEncode(client_id,'UTF-8')+
                '&client_secret='+EncodingUtil.urlEncode(client_secret,'UTF-8')+
                '&grant_type=client_credentials';
            req.setBody(payload);
            HttpResponse res = h.send(req);
            if(res.getstatus() == 'OK' && res.getstatusCode() == 200){
               Map<String,object> response = new Map<String,object>();
               response = (Map<String,object>) JSON.deserializeUntyped(res.getBody());
               String accessToken = (String) response.get('access_token'); 
               return accessToken;
                
            }
        
          return null;
        
    }
    
    
 }