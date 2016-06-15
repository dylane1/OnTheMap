//
//  NetworkRequestEngine.swift
//  On The Map
//
//  Created by Dylan Edwards on 6/15/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import Foundation

final class NetworkRequestEngine {
    
    private var getCompletion: GetDictionaryCompletion?
    
    typealias PostCompletion = () -> Void
    private var postCompletion: PostCompletion?
    
    internal func configure(withGetDictionaryCompletion get: GetDictionaryCompletion?, withPostCompletion post: PostCompletion?) {
        getCompletion   = get
        postCompletion  = post
    }
    
    internal func getJSONDictionary(withRequest request: NSMutableURLRequest) {
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            let httpResponse = response as! NSHTTPURLResponse
            magic("response status code: \(NSHTTPURLResponse.localizedStringForStatusCode(httpResponse.statusCode))")
            
            if error != nil {
                magic("\(error!.localizedDescription)")
                return
            }
            guard let data = data else { return }
            
            guard let jsonDict = try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! NSDictionary else {
                magic("INVALID JSON!!!")
                return
            }
            
            /// Get back on the main queue before returning the info
            dispatch_async(dispatch_get_main_queue()) {
                self.getCompletion?(jsonDict)
            }
        }
        task.resume()
    }
    
}