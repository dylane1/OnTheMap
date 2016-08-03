//
//  StudentInformation.swift
//  On The Map
//
//  Created by Dylan Edwards on 6/10/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import Foundation

struct StudentInformation {
    let firstName: String!
    let lastName: String!
    let uniqueKey: String!
    var latitude: Double!
    var longitude: Double!
    var mapString: String!
    var mediaURL: String!
    var updatedAt: NSDate?
    
    
    init(withInfoDictionary dict: NSDictionary) {
        firstName   = dict[Constants.Keys.firstName] as? String ?? ""
        lastName    = dict[Constants.Keys.lastName] as? String ?? ""
        uniqueKey   = dict[Constants.Keys.uniqueKey] as? String ?? ""
        latitude    = dict[Constants.Keys.latitude] as? Double ?? 0.00
        longitude   = dict[Constants.Keys.longitude] as? Double ?? 0.00
        mapString   = dict[Constants.Keys.mapString] as? String ?? ""
        mediaURL    = dict[Constants.Keys.mediaURL] as? String ?? ""
        updatedAt   = dict[Constants.Keys.updatedAt] as? NSDate
    }
}
