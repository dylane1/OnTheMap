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
        case invaldCredentials  = 403 /// status = 403
        case missingParameter   = 400 /// staus  = 400; parameter = "udacity.username" || "udacity.password"
    }
    
    fileprivate var presentActivityIndicator: ((_ completion: (() -> Void)?) -> Void)!
    fileprivate var loginSuccessClosure: (() -> Void)!
    fileprivate var presentErrorAlert: AlertPresentation!
    
    fileprivate var networkRequestService = NetworkRequestService()
    
    fileprivate lazy var studentInfoProvider = StudentInformationProvider.sharedInstance
    
    //MARK: - Configuration
    internal func configure(
        withActivityIndicatorPresentation presentAI: @escaping (_ completion: (() -> Void)?) -> Void,
        loginSuccessClosure success: @escaping () -> Void,
        alertPresentationClosure alertPresentation: @escaping AlertPresentation) {
        
        presentActivityIndicator    = presentAI
        loginSuccessClosure         = success
        presentErrorAlert           = alertPresentation
    }
    
    //MARK: - Perform network requests
    
    internal func login(withEmailAndPassword loginTuple:(email: String, password: String)? = nil, withFacebookToken token: FBSDKAccessToken? = nil) {
        
        let aiPresented = { [unowned self] in
            var request = URLRequest(url: URL(string: Constants.Network.udacitySessionURL)!)
            
            request.httpMethod = Constants.HTTPMethods.post
            request.addValue(Constants.HTTPHeaderFieldValues.applicationJSON, forHTTPHeaderField: Constants.HTTPHeaderFields.accept)
            request.addValue(Constants.HTTPHeaderFieldValues.applicationJSON, forHTTPHeaderField: Constants.HTTPHeaderFields.contentType)
            
            if loginTuple != nil {
                request.httpBody = "{\"udacity\": {\"username\": \"\(loginTuple!.email)\", \"password\": \"\(loginTuple!.password)\"}}".data(using: String.Encoding.utf8)
            } else if token != nil {
                request.httpBody = "{\"facebook_mobile\": {\"access_token\": \"\(token!.tokenString);\"}}".data(using: String.Encoding.utf8)
            } else {
                magic("Oh come on now, you gotta give me something to work with here...")
            }
            
            let requestCompletion = { [unowned self] (jsonDictionary: NSDictionary) in
                self.parseLoginJSON(jsonDictionary)
            }
            
            self.networkRequestService.configure(withRequestCompletion: requestCompletion, requestFailedClosure: self.presentErrorAlert)
            self.networkRequestService.requestJSONDictionary(withURLRequest: request as URLRequest, isUdacityLoginLogout: true)
        }
        presentActivityIndicator(aiPresented)
        
    }
    
    fileprivate func getPublicUserData(withAccountDict acctDict: NSDictionary) {
        
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/users/\(acctDict[Constants.Keys.key] as! String)")!)
        
        let requestCompletion = { [unowned self] (jsonDictionary: NSDictionary) in
            self.parsePublicUserDataJSON(jsonDictionary, userKey: acctDict[Constants.Keys.key] as! String)
        }
        
        networkRequestService.configure(withRequestCompletion: requestCompletion, requestFailedClosure: presentErrorAlert)
        networkRequestService.requestJSONDictionary(withURLRequest: request as URLRequest, isUdacityLoginLogout: true)
    }
    
    //MARK: - Parse results
    
    fileprivate func parseLoginJSON(_ jsonDictionary: NSDictionary) {
        
        guard let _ = jsonDictionary[Constants.Keys.session] as? NSDictionary,
              let accountDictionary = jsonDictionary[Constants.Keys.account] as? NSDictionary else {
                /// Invalid login
                
                guard let statusCode = jsonDictionary[Constants.Keys.status] as? Int,
                    let error = jsonDictionary[Constants.Keys.error] as? String else {
                        
                        presentErrorAlert((title: LocalizedStrings.AlertTitles.loginError, message: LocalizedStrings.AlertMessages.unknownLoginError))
                        
                        return
                }
                
                let messageString: String!
                
                switch statusCode {
                case Error.invaldCredentials.rawValue:
                    messageString = LocalizedStrings.AlertMessages.invalidCredentials
                case Error.missingParameter.rawValue:
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
                presentErrorAlert((title: LocalizedStrings.AlertTitles.loginError, message: messageString))
                return
        }
        /// Made it through with a valid account
        getPublicUserData(withAccountDict: accountDictionary)
    }
    
    fileprivate func parsePublicUserDataJSON(_ jsonDictionary: NSDictionary, userKey key: String) {
        
        guard let userDictionary = jsonDictionary[Constants.Keys.user] as? NSDictionary else {
            presentErrorAlert((title: LocalizedStrings.AlertTitles.userInfoError, message: LocalizedStrings.AlertMessages.userInfoError))
            return
        }
        
        let infoDictionary = NSMutableDictionary()
        
        guard let firstName = userDictionary[Constants.Keys.first_name] as? String,
            let lastName = userDictionary[Constants.Keys.last_name] as? String else {
                fatalError("No first or last name? All hope is lost... :[")
        }
        infoDictionary.setObject(firstName, forKey: Constants.Keys.firstName as NSCopying)
        infoDictionary.setObject(lastName, forKey: Constants.Keys.lastName as NSCopying)
        infoDictionary.setObject(key as String, forKey: Constants.Keys.uniqueKey as NSCopying)
        
        let currentUser = StudentInformation(withInfoDictionary: infoDictionary)
        
        studentInfoProvider.configure(withCurrentStudent: currentUser)
        
        loginSuccessClosure()
    }
}
