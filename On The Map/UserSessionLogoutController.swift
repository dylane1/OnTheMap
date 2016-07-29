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
    
    private var presentActivityIndicator: ((completion: (() -> Void)?) -> Void)!
    private var logoutSuccessClosure: (() -> Void)!
    private var presentErrorAlert: AlertPresentation!
    
    //MARK: - View Lifecycle
    
//    deinit { magic("being deinitialized   <----------------") }
    
    //MARK: - Configuration
    
    internal func configure(
        withActivityIndicatorPresentation presentAI: (completion: (() -> Void)?) -> Void,
        logoutSuccessClosure success: () -> Void,
        alertPresentationClosure alertPresentation: AlertPresentation) {
        
        presentActivityIndicator    = presentAI
        logoutSuccessClosure        = success
        presentErrorAlert           = alertPresentation    }
    
    //MARK: -
    internal func logout() {
        guard let _ = FBSDKAccessToken.currentAccessToken() as FBSDKAccessToken! else {
            udacityLogout()
            return
        }
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        logoutSuccessClosure()
        
    }
    
    private func udacityLogout() {
        let aiPresented = { /*[weak self]*/
            let request = NSMutableURLRequest(URL: NSURL(string: Constants.Network.udacitySessionURL)!)
            
            request.HTTPMethod = Constants.HTTPMethods.delete
            
            var xsrfCookie: NSHTTPCookie? = nil
            
            let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
            
            for cookie in sharedCookieStorage.cookies! {
                if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
            }
            
            if let xsrfCookie = xsrfCookie {
                request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
            }
            
            let requestCompletion = { /*[weak self]*/ (jsonDictionary: NSDictionary) in
                self.parseLogoutJSON(jsonDictionary)
            }
            
            let networkRequestService = NetworkRequestService()
            networkRequestService.configure(withRequestCompletion: requestCompletion, requestFailedClosure: self.presentErrorAlert)
            networkRequestService.requestJSONDictionary(withURLRequest: request, isUdacityLoginLogout: true)
        }
        presentActivityIndicator(completion: aiPresented)
    }
    
    //MARK: - Parse results
    
    private func parseLogoutJSON(jsonDictionary: NSDictionary) {
        
        guard let sessionDictionary = jsonDictionary[Constants.Keys.session] as? NSDictionary,
            let _ = sessionDictionary[Constants.Keys.id] as? String else {
                
                guard let statusCode = jsonDictionary[Constants.Keys.status] as? Int,
                    let _ = jsonDictionary[Constants.Keys.error] as? String else {
                        presentErrorAlert(alertParameters: (title: LocalizedStrings.AlertTitles.logoutError, message: LocalizedStrings.AlertMessages.unknownLogoutError))
                        return
                }
                let messageString = LocalizedStrings.AlertMessages.serverResponded + "\n\(statusCode): \(NSHTTPURLResponse.localizedStringForStatusCode(statusCode))"
                
                presentErrorAlert(alertParameters: (title: LocalizedStrings.AlertTitles.logoutError, message: messageString))
                return
        }
        logoutSuccessClosure()
    }
}
