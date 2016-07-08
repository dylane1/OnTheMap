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
    
    private var logoutCompletion: (() -> Void)!
    private var presentErrorAlert: AlertPresentation!
    
    deinit { magic("being deinitialized   <----------------") }
    
    internal func logout(withCompletion completion: () -> Void, errorHandler errorClosure: AlertPresentation) {
        guard let _ = FBSDKAccessToken.currentAccessToken() as FBSDKAccessToken! else {
            logoutCompletion    = completion
            presentErrorAlert   = errorClosure
            
            udacityLogout()
            return
        }
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        completion()
    }
    
    private func udacityLogout() {
        
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

        let requestCompletion = { [weak self] (jsonDictionary: NSDictionary) in
            self!.parseLogoutJSON(jsonDictionary)
        }
        
        let networkRequestService = NetworkRequestService()
        networkRequestService.configure(withRequestCompletion: requestCompletion, requestFailedClosure: presentErrorAlert)
        networkRequestService.requestJSONDictionary(withURLRequest: request, isUdacityLoginLogout: true)
        
    }
    
    //MARK: - Parse results
    
    private func parseLogoutJSON(jsonDictionary: NSDictionary) {
         magic("logoutDict: \(jsonDictionary)")
        
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
        /// Dismiss Tab Bar controller after logout
        logoutCompletion()
    }
}
