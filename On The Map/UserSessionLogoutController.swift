//
//  UserSessionLogoutController.swift
//  On The Map
//
//  Created by Dylan Edwards on 7/5/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import Foundation
import FBSDKLoginKit

final class UserSessionLogoutController {
    
    fileprivate var presentActivityIndicator: (((() -> Void)?) -> Void)!
    fileprivate var logoutSuccessClosure: (() -> Void)!
    fileprivate var presentErrorAlert: AlertPresentation!
    
    //MARK: - Configuration
    
    internal func configure(
        withActivityIndicatorPresentation presentAI: @escaping (_ completion: (() -> Void)?) -> Void,
        logoutSuccessClosure success: @escaping () -> Void,
        alertPresentationClosure alertPresentation: @escaping AlertPresentation) {
        
        presentActivityIndicator    = presentAI
        logoutSuccessClosure        = success
        presentErrorAlert           = alertPresentation    }
    
    //MARK: -
    internal func logout() {
        guard let _ = FBSDKAccessToken.current() as FBSDKAccessToken! else {
            udacityLogout()
            return
        }
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        logoutSuccessClosure()
        
    }
    
    fileprivate func udacityLogout() {
        let aiPresented = { [weak self] in
            let request = NSMutableURLRequest(url: URL(string: Constants.Network.udacitySessionURL)!)
            
            request.httpMethod = Constants.HTTPMethods.delete
            
            var xsrfCookie: HTTPCookie? = nil
            
            let sharedCookieStorage = HTTPCookieStorage.shared
            
            for cookie in sharedCookieStorage.cookies! {
                if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
            }
            
            if let xsrfCookie = xsrfCookie {
                request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
            }
            
            let requestCompletion = { [weak self] (jsonDictionary: NSDictionary) in
                self!.parseLogoutJSON(jsonDictionary)
            }
            
            let networkRequestService = NetworkRequestService()
            networkRequestService.configure(withRequestCompletion: requestCompletion, requestFailedClosure: self!.presentErrorAlert)
            networkRequestService.requestJSONDictionary(withURLRequest: request, isUdacityLoginLogout: true)
        }
        presentActivityIndicator(aiPresented)
    }
    
    //MARK: - Parse results
    
    fileprivate func parseLogoutJSON(_ jsonDictionary: NSDictionary) {
        
        guard let sessionDictionary = jsonDictionary[Constants.Keys.session] as? NSDictionary,
            let _ = sessionDictionary[Constants.Keys.id] as? String else {
                
                guard let statusCode = jsonDictionary[Constants.Keys.status] as? Int,
                    let _ = jsonDictionary[Constants.Keys.error] as? String else {
                        presentErrorAlert((title: LocalizedStrings.AlertTitles.logoutError, message: LocalizedStrings.AlertMessages.unknownLogoutError))
                        return
                }
                let messageString = LocalizedStrings.AlertMessages.serverResponded + "\n\(statusCode): \(HTTPURLResponse.localizedString(forStatusCode: statusCode))"
                
                presentErrorAlert((title: LocalizedStrings.AlertTitles.logoutError, message: messageString))
                return
        }
        logoutSuccessClosure()
    }
}
