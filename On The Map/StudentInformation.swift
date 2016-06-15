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
    let latitude: Double!
    let longitude: Double!
    let mapString: String!
    let mediaURL: String!
    
    init(withFirstName fn: String, lastName ln: String, latitude lat: Double, longitude lon: Double, mapString ms: String, mediaURL url: String) {
        firstName   = fn
        lastName    = ln
        latitude    = lat
        longitude   = lon
        mapString   = ms
        mediaURL    = url
    }
}
