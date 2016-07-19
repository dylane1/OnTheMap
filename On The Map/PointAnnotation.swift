//
//  PointAnnotation.swift
//  On The Map
//
//  Created by Dylan Edwards on 7/15/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit
import MapKit

class PointAnnotation: MKPointAnnotation {
    var pinColor: UIColor
    
    init(pinColor color: UIColor) {
        pinColor = color
        super.init()
    }
}
