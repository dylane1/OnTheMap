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
            self.parseLoginJSON(jsonDict)
        }
        
        networkRequestEngine.configure(withGetDictionaryCompletion: requestCompletion)
        networkRequestEngine.getJSONDictionary(withRequest: request, isUdacityLogin: true)
    }
    
    //MARK: - Parse JSON
    
    private func parseLoginJSON(jsonDict: NSDictionary) {
        
        if jsonDict["session"] != nil && jsonDict["account"] != nil {

            getPublicUserData(withAccountDict: jsonDict["account"] as! NSDictionary)

        } else {
            magic("Invalid login")
            //TODO: pop alert
        }
    }
    
    private func getPublicUserData(withAccountDict acctDict: NSDictionary) {
        
        magic("key: \(acctDict["key"] as! String)")
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/\(acctDict["key"] as! String)")!)
        
        let requestCompletion = { (jsonDict: NSDictionary) in
            self.parsePublicUserDataJSON(jsonDict, userKey: acctDict["key"] as! String)
        }
        
        networkRequestEngine.configure(withGetDictionaryCompletion: requestCompletion)
        networkRequestEngine.getJSONDictionary(withRequest: request, isUdacityLogin: true)
    }
    
    private func parsePublicUserDataJSON(jsonDict: NSDictionary, userKey key: String) {
        
        if jsonDict["user"] != nil {
            guard let userDict = jsonDict["user"] as? NSDictionary else {
                magic("noooooo....")
                return
            }
            
            let infoDictionary = NSMutableDictionary()
            
            infoDictionary.setObject(userDict["first_name"] as! String, forKey: Constants.Keys.firstName)
            infoDictionary.setObject(userDict["last_name"] as! String, forKey: Constants.Keys.lastName)
            infoDictionary.setObject(key as String, forKey: Constants.Keys.uniqueKey)
            
            let currentUser = StudentInformation(withInfoDictionary: infoDictionary)
            
            studentInfoProvider.configure(withCurrentStudent: currentUser)

            /// Need to go back to main thread before calling performSegue
            dispatch_async(dispatch_get_main_queue()) {
                self.udacitySuccessfulLogin()
            }
        } else {
            magic("no user data :(")
        }
        
    }
}




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






































