//
//  LoginValidator.swift
//  On The Map
//
//  Created by Dylan Edwards on 5/25/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import Foundation

final class LoginValidator {

    enum Error: Int {
        case InvaldCredentials  = 403 /// status = 403
        case MissingParameter   = 400 /// staus  = 400; parameter = "udacity.username" || "udacity.password"
    }
    
    
    private var loginSuccessClosure: (() -> Void)!
    private var alertPresentationClosure: AlertPresentationClosure!
    
    private var networkRequestService = NetworkRequestService()
    
    private lazy var studentInfoProvider = StudentInformationProvider.sharedInstance
    
    //MARK: - Configuration
    internal func configure(withLoginSuccessClosure successClosure: () -> Void, alertPresentationClosure alertClosure: AlertPresentationClosure) {
        loginSuccessClosure         = successClosure
        alertPresentationClosure    = alertClosure
    }
    
    //MARK: - Perform network requests
    
    internal func verifyLogin(withEmail email: String, password: String) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let requestCompletion = { [unowned self] (jsonDictionary: NSDictionary) in
            self.parseLoginJSON(jsonDictionary)
        }
        
        networkRequestService.configure(withRequestCompletion: requestCompletion, alertPresentationClosure: alertPresentationClosure)
        networkRequestService.requestJSONDictionary(withURLRequest: request, isUdacityLogin: true)
    }
    
    private func getPublicUserData(withAccountDict acctDict: NSDictionary) {
        
//        magic("key: \(acctDict[Constants.Keys.key] as! String)")
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/\(acctDict[Constants.Keys.key] as! String)")!)
        
        let requestCompletion = { [unowned self] (jsonDictionary: NSDictionary) in
            self.parsePublicUserDataJSON(jsonDictionary, userKey: acctDict[Constants.Keys.key] as! String)
        }
        
        networkRequestService.configure(withRequestCompletion: requestCompletion, alertPresentationClosure: alertPresentationClosure)
        networkRequestService.requestJSONDictionary(withURLRequest: request, isUdacityLogin: true)
    }
    
    //MARK: - Parse results
    
    private func parseLoginJSON(jsonDictionary: NSDictionary) {
        magic("loginDict: \(jsonDictionary)")
        
        guard let _ = jsonDictionary[Constants.Keys.session] as? String,
              let accountDictionary = jsonDictionary[Constants.Keys.account] as? NSDictionary else {
                /// Invalid login
                
                guard let statusCode = jsonDictionary[Constants.Keys.status] as? Int,
                    let _ = jsonDictionary[Constants.Keys.error] as? String else {
                        alertPresentationClosure?(LocalizedStrings.AlertTitles.loginError, LocalizedStrings.AlertMessages.unknownLoginError)
                        return
                }
                
                var messageString = ""
                
                switch statusCode {
                case Error.InvaldCredentials.rawValue:
                    messageString += LocalizedStrings.AlertMessages.invalidCredentials
                default:
                    /// Missing Parameter
                    if let missingParameter = jsonDictionary[Constants.Keys.parameter] as? String {
                        switch missingParameter {
                        case Constants.LoginErrorResponses.missingUsername:
                            messageString += LocalizedStrings.AlertMessages.pleaseEnterUsername
                        default:
                            messageString += LocalizedStrings.AlertMessages.pleaseEnterPassword
                        }
                    }
                }
                
                alertPresentationClosure?(LocalizedStrings.AlertTitles.loginError, messageString)
                return
        }
        /// Made it through with a valid account
        getPublicUserData(withAccountDict: accountDictionary)
    }
    
    private func parsePublicUserDataJSON(jsonDictionary: NSDictionary, userKey key: String) {
        
        if jsonDictionary[Constants.Keys.user] != nil {
            guard let userDict = jsonDictionary[Constants.Keys.user] as? NSDictionary else {
                magic("noooooo....")
                return
            }
            
            let infoDictionary = NSMutableDictionary()
            
            infoDictionary.setObject(userDict[Constants.Keys.first_name] as! String, forKey: Constants.Keys.firstName)
            infoDictionary.setObject(userDict[Constants.Keys.last_name] as! String, forKey: Constants.Keys.lastName)
            infoDictionary.setObject(key as String, forKey: Constants.Keys.uniqueKey)
            
            let currentUser = StudentInformation(withInfoDictionary: infoDictionary)
            
            studentInfoProvider.configure(withCurrentStudent: currentUser)

            /// Need to go back to main thread before calling performSegue
            dispatch_async(dispatch_get_main_queue()) {
                self.loginSuccessClosure()
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
 {
 error = "Account not found or invalid credentials.";
 status = 403;
 }
 
 *No username error
 {
 error = "trails.Error 400: Missing parameter 'username'";
 parameter = "udacity.username";
 status = 400;
 }
 * No pw:
 {
 error = "trails.Error 400: Missing parameter 'password'";
 parameter = "udacity.password";
 status = 400;
 }
 
 
 
 
 */






































