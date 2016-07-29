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
    
    private var presentActivityIndicator: ((completion: (() -> Void)?) -> Void)!
    private var loginSuccessClosure: (() -> Void)!
    private var presentErrorAlert: AlertPresentation!
    
    private var networkRequestService = NetworkRequestService()
    
    private lazy var studentInfoProvider = StudentInformationProvider.sharedInstance
    
    //MARK: - Configuration
    internal func configure(
        withActivityIndicatorPresentation presentAI: (completion: (() -> Void)?) -> Void,
        loginSuccessClosure success: () -> Void,
        alertPresentationClosure alertPresentation: AlertPresentation) {
        
        presentActivityIndicator    = presentAI
        loginSuccessClosure         = success
        presentErrorAlert           = alertPresentation
    }
    
    //MARK: - Perform network requests
    
    internal func login(withEmailAndPassword loginTuple:(email: String, password: String)? = nil, withFacebookToken token: FBSDKAccessToken? = nil) {
        
        let aiPresented = { /*[weak self]*/
            let request = NSMutableURLRequest(URL: NSURL(string: Constants.Network.udacitySessionURL)!)
            
            request.HTTPMethod = Constants.HTTPMethods.post
            request.addValue(Constants.HTTPHeaderFieldValues.applicationJSON, forHTTPHeaderField: Constants.HTTPHeaderFields.accept)
            request.addValue(Constants.HTTPHeaderFieldValues.applicationJSON, forHTTPHeaderField: Constants.HTTPHeaderFields.contentType)
            
            if loginTuple != nil {
                request.HTTPBody = "{\"udacity\": {\"username\": \"\(loginTuple!.email)\", \"password\": \"\(loginTuple!.password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
            } else if token != nil {
                request.HTTPBody = "{\"facebook_mobile\": {\"access_token\": \"\(token!.tokenString);\"}}".dataUsingEncoding(NSUTF8StringEncoding)
            } else {
                magic("Oh come on now, you gotta give me something to work with here...")
            }
            
            let requestCompletion = { /*[weak self]*/ (jsonDictionary: NSDictionary) in
                self.parseLoginJSON(jsonDictionary)
            }
            
            self.networkRequestService.configure(withRequestCompletion: requestCompletion, requestFailedClosure: self.presentErrorAlert)
            self.networkRequestService.requestJSONDictionary(withURLRequest: request, isUdacityLoginLogout: true)
        }
        presentActivityIndicator(completion: aiPresented)
        
    }
    
    private func getPublicUserData(withAccountDict acctDict: NSDictionary) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/\(acctDict[Constants.Keys.key] as! String)")!)
        
        let requestCompletion = { /*[unowned self]*/ (jsonDictionary: NSDictionary) in
            self.parsePublicUserDataJSON(jsonDictionary, userKey: acctDict[Constants.Keys.key] as! String)
        }
        
        networkRequestService.configure(withRequestCompletion: requestCompletion, requestFailedClosure: presentErrorAlert)
        networkRequestService.requestJSONDictionary(withURLRequest: request, isUdacityLoginLogout: true)
    }
    
    //MARK: - Parse results
    
    private func parseLoginJSON(jsonDictionary: NSDictionary) {
        
        guard let _ = jsonDictionary[Constants.Keys.session] as? NSDictionary,
              let accountDictionary = jsonDictionary[Constants.Keys.account] as? NSDictionary else {
                /// Invalid login
                
                guard let statusCode = jsonDictionary[Constants.Keys.status] as? Int,
                    let error = jsonDictionary[Constants.Keys.error] as? String else {
                        
                        presentErrorAlert(alertParameters: (title: LocalizedStrings.AlertTitles.loginError, message: LocalizedStrings.AlertMessages.unknownLoginError))
                        
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
                        messageString = jsonDictionary[Constants.Keys.error] as! String
                    }
                default:
                    /// Something else
                    messageString = LocalizedStrings.AlertMessages.serverResponded + "\n\(error)"
                }
                presentErrorAlert(alertParameters: (title: LocalizedStrings.AlertTitles.loginError, message: messageString))
                return
        }
        /// Made it through with a valid account
        getPublicUserData(withAccountDict: accountDictionary)
    }
    
    private func parsePublicUserDataJSON(jsonDictionary: NSDictionary, userKey key: String) {
        
        guard let userDictionary = jsonDictionary[Constants.Keys.user] as? NSDictionary else {
            presentErrorAlert(alertParameters: (title: LocalizedStrings.AlertTitles.userInfoError, message: LocalizedStrings.AlertMessages.userInfoError))
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
        
        loginSuccessClosure()
    }
}
