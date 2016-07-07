//
//  StudentLocationRequestable.swift
//  On The Map
//
//  Created by Dylan Edwards on 6/21/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import Foundation

protocol StudentLocationRequestable { }

extension StudentLocationRequestable {
    
    internal func createStudentLocationRequest(withHTTPMethod method: String = Constants.HTTPMethods.get, uniqueKey key: String? = nil, objectId id: String? = nil) -> NSMutableURLRequest {
        
        var urlString = "https://api.parse.com/1/classes/StudentLocation"

        /// Requesting an array of students
        if key == nil && id == nil {
            urlString += "?limit=100&limit=200&order=-updatedAt"
        }
        
        /// Requesting user location
        if key != nil {
            urlString += "?where=%7B%22uniqueKey%22%3A%22\(key!)%22%7D"
        }
        
        /// Updating user location
        if id != nil {
            urlString += "/\(id!)"
        }
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        
        request.addValue(Constants.Network.parseAppID, forHTTPHeaderField: Constants.HTTPHeaderFields.xParseAppId)
        request.addValue(Constants.Network.restAPIKey, forHTTPHeaderField: Constants.HTTPHeaderFields.xParseRestAPIKey)
        
        request.HTTPMethod = method
        
        if method != Constants.HTTPMethods.get {
            request.addValue(Constants.HTTPHeaderFieldValues.applicationJSON, forHTTPHeaderField: Constants.HTTPHeaderFields.contentType)
        }

        return request
    }
}
