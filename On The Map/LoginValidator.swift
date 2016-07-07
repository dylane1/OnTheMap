//
//  LoginValidator.swift
//  On The Map
//
//  Created by Dylan Edwards on 5/25/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import Foundation
import FBSDKLoginKit

final class LoginValidator {

    enum Error: Int {
        case InvaldCredentials  = 403 /// status = 403
        case MissingParameter   = 400 /// staus  = 400; parameter = "udacity.username" || "udacity.password"
    }
    
    private var loginSuccessClosure: (() -> Void)!
    private var alertPresentationClosureWithParameters: AlertPresentationClosureWithParameters!
    
    private var networkRequestService = NetworkRequestService()
    
    private lazy var studentInfoProvider = StudentInformationProvider.sharedInstance
    
    //MARK: - Configuration
    internal func configure(withLoginSuccessClosure successClosure: () -> Void, alertPresentationClosure alertClosure: AlertPresentationClosureWithParameters) {
        loginSuccessClosure                     = successClosure
        alertPresentationClosureWithParameters  = alertClosure
    }
    
    //MARK: - Perform network requests
    
    internal func login(withEmailAndPassword loginTuple:(email: String, password: String)? = nil, withFacebookToken token: FBSDKAccessToken? = nil) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: Constants.Network.udacitySessionURL)!)
        
        request.HTTPMethod = Constants.HTTPMethods.post
        request.addValue(Constants.HTTPHeaderFieldValues.applicationJSON, forHTTPHeaderField: Constants.HTTPHeaderFields.accept)
        request.addValue(Constants.HTTPHeaderFieldValues.applicationJSON, forHTTPHeaderField: Constants.HTTPHeaderFields.contentType)
        
        if loginTuple != nil {
            request.HTTPBody = "{\"udacity\": {\"username\": \"\(loginTuple!.email)\", \"password\": \"\(loginTuple!.password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        } else if token != nil {
            magic("facebook token: \(token!.tokenString)")
            request.HTTPBody = "{\"facebook_mobile\": {\"access_token\": \"\(token!.tokenString);\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        } else {
//            fatalError("Come on now, you gotta give me something to work with here...")
        }
        
        
        let requestCompletion = { [unowned self] (jsonDictionary: NSDictionary) in
            self.parseLoginJSON(jsonDictionary)
        }
        
        networkRequestService.configure(withRequestCompletion: requestCompletion, alertPresentationClosure: alertPresentationClosureWithParameters)
        networkRequestService.requestJSONDictionary(withURLRequest: request, isUdacityLoginLogout: true)
    }
    
    private func getPublicUserData(withAccountDict acctDict: NSDictionary) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/\(acctDict[Constants.Keys.key] as! String)")!)
        
        let requestCompletion = { [unowned self] (jsonDictionary: NSDictionary) in
            self.parsePublicUserDataJSON(jsonDictionary, userKey: acctDict[Constants.Keys.key] as! String)
        }
        
        networkRequestService.configure(withRequestCompletion: requestCompletion, alertPresentationClosure: alertPresentationClosureWithParameters)
        networkRequestService.requestJSONDictionary(withURLRequest: request, isUdacityLoginLogout: true)
    }
    
    //MARK: - Parse results
    
    private func parseLoginJSON(jsonDictionary: NSDictionary) {
        magic("loginDict: \(jsonDictionary)")
        
        guard let _ = jsonDictionary[Constants.Keys.session] as? NSDictionary,
              let accountDictionary = jsonDictionary[Constants.Keys.account] as? NSDictionary else {
                /// Invalid login
                
                guard let statusCode = jsonDictionary[Constants.Keys.status] as? Int,
                    let error = jsonDictionary[Constants.Keys.error] as? String else {
                        alertPresentationClosureWithParameters?((title: LocalizedStrings.AlertTitles.loginError, message: LocalizedStrings.AlertMessages.unknownLoginError))
                        return
                }
                
                let messageString: String!
                
                switch statusCode {
                case Error.InvaldCredentials.rawValue:
                    messageString = LocalizedStrings.AlertMessages.invalidCredentials
                case Error.MissingParameter.rawValue:
                    if let missingParameter = jsonDictionary[Constants.Keys.parameter] as? String {
                        switch missingParameter {
                        case Constants.LoginErrorResponses.missingUsername:
                            messageString = LocalizedStrings.AlertMessages.pleaseEnterUsername
                        default:
                            messageString = LocalizedStrings.AlertMessages.pleaseEnterPassword
                        }
                    } else {
                        messageString = LocalizedStrings.AlertMessages.unknownLoginError
                    }
                default:
                    /// Something else
                    messageString = LocalizedStrings.AlertMessages.serverResponded + "\n\(error)"
                }
                
                alertPresentationClosureWithParameters?((title: LocalizedStrings.AlertTitles.loginError, message: messageString))
                return
        }
        /// Made it through with a valid account
        getPublicUserData(withAccountDict: accountDictionary)
    }
    
    private func parsePublicUserDataJSON(jsonDictionary: NSDictionary, userKey key: String) {
//        magic("userDictionary: \(jsonDictionary)")
        guard let userDictionary = jsonDictionary[Constants.Keys.user] as? NSDictionary else {
            alertPresentationClosureWithParameters?((title: LocalizedStrings.AlertTitles.userInfoError, message: LocalizedStrings.AlertMessages.userInfoError))
            return
        }
        
        let infoDictionary = NSMutableDictionary()
        
        guard let firstName = userDictionary[Constants.Keys.first_name] as? String,
            lastName = userDictionary[Constants.Keys.last_name] as? String else {
                fatalError("No first or last name? All hope is lost... :[")
        }
        infoDictionary.setObject(firstName, forKey: Constants.Keys.firstName)
        infoDictionary.setObject(lastName, forKey: Constants.Keys.lastName)
        infoDictionary.setObject(key as String, forKey: Constants.Keys.uniqueKey)
        
        let currentUser = StudentInformation(withInfoDictionary: infoDictionary)
        
        studentInfoProvider.configure(withCurrentStudent: currentUser)
        
        self.loginSuccessClosure()
    }
}







































