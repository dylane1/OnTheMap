//
//  ParseAPIRequestable.swift
//  On The Map
//
//  Created by Dylan Edwards on 6/21/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import Foundation

protocol ParseAPIRequestable {

}

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
        
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        if isPost || isPut {
            request.HTTPMethod = (isPost) ? "POST" : "PUT"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        return request
    }
}
