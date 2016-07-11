//
//  LocationMarkerIconDrawable.swift
//  On The Map
//
//  Created by Dylan Edwards on 7/11/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

protocol LocationMarkerIconDrawable { }

extension LocationMarkerIconDrawable where Self: IconProviderProtocol {
    internal func drawLocationMarkerWithColor(fillColor: UIColor) {
        //// Symbolicons-Junior 2
        //// location Drawing
        let locationPath = UIBezierPath()
        locationPath.moveToPoint(CGPoint(x: 20, y: 21))
        locationPath.addCurveToPoint(CGPoint(x: 16, y: 17), controlPoint1: CGPoint(x: 17.79, y: 21), controlPoint2: CGPoint(x: 16, y: 19.21))
        locationPath.addCurveToPoint(CGPoint(x: 20, y: 13), controlPoint1: CGPoint(x: 16, y: 14.79), controlPoint2: CGPoint(x: 17.79, y: 13))
        locationPath.addCurveToPoint(CGPoint(x: 24, y: 17), controlPoint1: CGPoint(x: 22.21, y: 13), controlPoint2: CGPoint(x: 24, y: 14.79))
        locationPath.addCurveToPoint(CGPoint(x: 20, y: 21), controlPoint1: CGPoint(x: 24, y: 19.21), controlPoint2: CGPoint(x: 22.21, y: 21))
        locationPath.closePath()
        locationPath.moveToPoint(CGPoint(x: 20, y: 5))
        locationPath.addCurveToPoint(CGPoint(x: 8, y: 17), controlPoint1: CGPoint(x: 12, y: 5), controlPoint2: CGPoint(x: 8, y: 11))
        locationPath.addCurveToPoint(CGPoint(x: 20, y: 37), controlPoint1: CGPoint(x: 8, y: 23), controlPoint2: CGPoint(x: 20, y: 37))
        locationPath.addCurveToPoint(CGPoint(x: 32, y: 17), controlPoint1: CGPoint(x: 20, y: 37), controlPoint2: CGPoint(x: 32, y: 23))
        locationPath.addCurveToPoint(CGPoint(x: 20, y: 5), controlPoint1: CGPoint(x: 32, y: 11), controlPoint2: CGPoint(x: 28, y: 5))
        locationPath.closePath()
        locationPath.miterLimit = 4;
        
        locationPath.usesEvenOddFillRule = true;
        
        fillColor.setFill()
        locationPath.fill()
    }
}
