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
    internal func getParseAPIRequest(isPostMethod isPost: Bool = false) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        if isPost {
            request.HTTPMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        return request
    }
}
