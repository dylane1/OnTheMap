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
    
    init(withInfoDictionary dict: NSDictionary) {
        firstName   = dict["firstName"] as! String
        lastName    = dict["lastName"] as! String
        latitude    = dict["latitude"] as! Double
        longitude   = dict["longitude"] as! Double
        mapString   = dict["mapString"] as! String
        mediaURL    = dict["mediaURL"] as! String
    }
}
