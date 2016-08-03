//
//  NetworkRequestService.swift
//  On The Map
//
//  Created by Dylan Edwards on 6/15/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import Foundation

final class NetworkRequestService {
    
    private var requestCompletion: GetDictionaryCompletion!
    private var presentErrorAlert: AlertPresentation!
    
    internal func configure(withRequestCompletion reqCompletion: GetDictionaryCompletion, requestFailedClosure requestFailed: AlertPresentation) {
        requestCompletion   = reqCompletion
        presentErrorAlert   = requestFailed
    }
    
    internal func requestJSONDictionary(withURLRequest request: NSMutableURLRequest, isUdacityLoginLogout uLoginLogout: Bool = false) {
        
        /// Check to see if connected to the internet first...
        if !Reachability.isConnectedToNetwork() {
            presentErrorAlert(alertParameters: (title: LocalizedStrings.AlertTitles.noInternetConnection, message: LocalizedStrings.AlertMessages.connectToInternet))
        }
        
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            guard var data = data, let response = response where error == nil else {
                dispatch_async(dispatch_get_main_queue()) {
                    self.presentErrorAlert(alertParameters: (title: LocalizedStrings.AlertTitles.error, message: error!.localizedDescription))
                }
                return
            }
            
            let httpResponse = response as! NSHTTPURLResponse

            if httpResponse.statusCode < 200 || httpResponse.statusCode > 299 {
                magic("Error! status: \(NSHTTPURLResponse.localizedStringForStatusCode(httpResponse.statusCode))")
            }
            
            if uLoginLogout {
                data = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            }
            
            do {
                let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! NSDictionary
                
                /// Get back on the main queue before returning the info
                dispatch_async(dispatch_get_main_queue()) {
                    self.requestCompletion?(jsonDictionary)
                }
            }catch {
                fatalError("Not a JSON Dictionary :[")
            }
        }
        task.resume()
    }
    
}
