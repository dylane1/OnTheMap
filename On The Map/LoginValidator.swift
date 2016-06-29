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
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/\(acctDict[Constants.Keys.key] as! String)")!)
        
        let requestCompletion = { [unowned self] (jsonDictionary: NSDictionary) in
            self.parsePublicUserDataJSON(jsonDictionary, userKey: acctDict[Constants.Keys.key] as! String)
        }
        
        networkRequestService.configure(withRequestCompletion: requestCompletion, alertPresentationClosure: alertPresentationClosure)
        networkRequestService.requestJSONDictionary(withURLRequest: request, isUdacityLogin: true)
    }
    
    //MARK: - Parse results
    
    private func parseLoginJSON(jsonDictionary: NSDictionary) {
//        magic("loginDict: \(jsonDictionary)")
        
        guard let _ = jsonDictionary[Constants.Keys.session] as? NSDictionary,
              let accountDictionary = jsonDictionary[Constants.Keys.account] as? NSDictionary else {
                /// Invalid login
                
                guard let statusCode = jsonDictionary[Constants.Keys.status] as? Int,
                    let _ = jsonDictionary[Constants.Keys.error] as? String else {
                        alertPresentationClosure?(LocalizedStrings.AlertTitles.loginError, LocalizedStrings.AlertMessages.unknownLoginError)
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
                    /// Unknown?
                    messageString = LocalizedStrings.AlertMessages.unknownLoginError + ": \(statusCode)"
                }
                
                alertPresentationClosure?(LocalizedStrings.AlertTitles.loginError, messageString)
                return
        }
        /// Made it through with a valid account
        getPublicUserData(withAccountDict: accountDictionary)
    }
    
    private func parsePublicUserDataJSON(jsonDictionary: NSDictionary, userKey key: String) {
//        magic("userDictionary: \(jsonDictionary)")
        guard let userDictionary = jsonDictionary[Constants.Keys.user] as? NSDictionary else {
            alertPresentationClosure?(LocalizedStrings.AlertTitles.userInfoError, LocalizedStrings.AlertMessages.userInfoError)
            return
        }
        
        let infoDictionary = NSMutableDictionary()
        
        guard let firstName = userDictionary[Constants.Keys.first_name] as? String,
            lastName = userDictionary[Constants.Keys.first_name] as? String else {
                fatalError("No first or last name? :[")
        }
        infoDictionary.setObject(firstName, forKey: Constants.Keys.firstName)
        infoDictionary.setObject(lastName, forKey: Constants.Keys.lastName)
        infoDictionary.setObject(key as String, forKey: Constants.Keys.uniqueKey)
        
        let currentUser = StudentInformation(withInfoDictionary: infoDictionary)
        
        studentInfoProvider.configure(withCurrentStudent: currentUser)
        
        self.loginSuccessClosure()
    }
}







































