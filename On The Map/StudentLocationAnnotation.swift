//
//  StudentLocationAnnotation.swift
//  On The Map
//
//  Created by Dylan Edwards on 6/16/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import MapKit
import Foundation

final class StudentLocationAnnotation: NSObject, MKAnnotation, ReusableView {
    let title: String?
    let mediaURL: String
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, mediaURL: String, locationName: String, coordinate: CLLocationCoordinate2D) {
        self.title          = title
        self.mediaURL       = mediaURL
        self.locationName   = locationName
        self.coordinate     = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return mediaURL
    }
}
