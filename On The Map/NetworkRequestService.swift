//
//  NetworkRequestService.swift
//  On The Map
//
//  Created by Dylan Edwards on 6/15/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import Foundation

final class NetworkRequestService {
    
    private var requestCompletion: GetDictionaryCompletion?
    
    internal func configure(withRequestCompletion completion: GetDictionaryCompletion) {
        requestCompletion = completion
    }
    
    internal func requestJSONDictionary(withURLRequest request: NSMutableURLRequest, isUdacityLogin uLogin: Bool = false) {
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            guard var data = data, let response = response where error == nil else {
                
                return
            }
            
            let httpResponse = response as! NSHTTPURLResponse
            magic("response status code: \(NSHTTPURLResponse.localizedStringForStatusCode(httpResponse.statusCode))")
            
//            
//            if error != nil {
//                magic("\(error!.localizedDescription)")
//                return
//            }
            
            if uLogin {
                data = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            }
            guard let jsonDict = try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! NSDictionary else {
                magic("INVALID JSON!!!")
                return
            }
            
            /// Get back on the main queue before returning the info
            dispatch_async(dispatch_get_main_queue()) {
                self.requestCompletion?(jsonDict)
            }
        }
        task.resume()
    }
    
}
