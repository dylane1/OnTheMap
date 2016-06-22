//
//  LoginValidation.swift
//  On The Map
//
//  Created by Dylan Edwards on 5/25/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import Foundation

final class LoginValidation {
    
    enum Error: ErrorType {
        case InvalidJSON
    }
    
    private var udacitySuccessfulLogin: LoginSuccess!
    
    private var networkRequestEngine = NetworkRequestEngine()
    
    private lazy var studentInfoProvider = StudentInformationProvider.sharedInstance
    
    //MARK: - Configuration
    internal func configure(withSuccessClosure closure: LoginSuccess) {
        udacitySuccessfulLogin = closure
    }
    
    //MARK: - Network connect
    
    internal func verifyLogin(withEmail email: String, password: String) {
//        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let requestCompletion = { (jsonDict: NSDictionary) in
            self.parseThatJSON(jsonDict)
        }
        
        networkRequestEngine.configure(withGetDictionaryCompletion: requestCompletion)
        networkRequestEngine.getJSONDictionary(withRequest: request, isUdacityLogin: true)
    }
    
    //MARK: - Parse JSON
    
    private func parseThatJSON(jsonDict: NSDictionary) {
        
        if jsonDict["session"] != nil {
            
            
            dispatch_async(dispatch_get_main_queue()) {
                self.udacitySuccessfulLogin()
            }
            
        } else {
            magic("Invalid login")
            //TODO: pop alert
        }
    }
}



/**
 * Sample response:
 
 {
 "account":{
 "registered":true,
 "key":"3903878747"
 },
 "session":{
 "id":"1457628510Sc18f2ad4cd3fb317fb8e028488694088",
 "expiration":"2015-05-10T16:48:30.760460Z"
 }
 }
 */

/**
 * Real Response:
 [
 "session": {
 expiration = "2016-08-02T00:11:08.171300Z";
 id = 1496448668S91843fdbda6e2232a715d7e82fcf19df;
 },
 "account": {
 key = u20327308;
 registered = 1;
 }
 ]
 
 * Invalid login:
 LoginValidation.parseThatJSON[74]: json:
 [
 "status": 403,
 "error": Account not found or invalid credentials.
 ]
 */ 






































