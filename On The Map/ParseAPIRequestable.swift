//
//  ParseAPIRequestable.swift
//  On The Map
//
//  Created by Dylan Edwards on 6/21/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import Foundation

protocol ParseAPIRequestable { }

extension ParseAPIRequestable {
    
    internal func getParseAPIRequest(isPostMethod isPost: Bool = false, isPutMethod isPut: Bool = false, withUniqueKey key: String? = nil, withObjectId id: String? = nil) -> NSMutableURLRequest {
        var urlString = "https://api.parse.com/1/classes/StudentLocation"

        if key != nil {
            urlString += "?where=%7B%22uniqueKey%22%3A%22\(key!)%22%7D"
        }
        
        if id != nil {
            urlString += "/\(id!)"
        }
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        
        request.addValue(Constants.Network.parseAppID, forHTTPHeaderField: Constants.HTTPHeaderFields.xParseAppId)
        request.addValue(Constants.Network.restAPIKey, forHTTPHeaderField: Constants.HTTPHeaderFields.xParseRestAPIKey)
        
        if isPost || isPut {
            request.HTTPMethod = (isPost) ? Constants.HTTPMethods.post : Constants.HTTPMethods.put
            request.addValue(Constants.HTTPHeaderFieldValues.applicationJSON, forHTTPHeaderField: Constants.HTTPHeaderFields.contentType)
        }
        return request
    }
}
