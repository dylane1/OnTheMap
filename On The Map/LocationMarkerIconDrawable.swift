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
        locationPath.miterLimit = 4
        
        locationPath.usesEvenOddFillRule = true
        
        fillColor.setFill()
        locationPath.fill()
    }
    
    internal func draw30PointLocationMarkerWithColor(fillColor: UIColor) {
        let locationPath = UIBezierPath()
        locationPath.moveToPoint(CGPoint(x: 15, y: 15))
        locationPath.addCurveToPoint(CGPoint(x: 12, y: 12), controlPoint1: CGPoint(x: 13.34, y: 15), controlPoint2: CGPoint(x: 12, y: 13.66))
        locationPath.addCurveToPoint(CGPoint(x: 15, y: 9), controlPoint1: CGPoint(x: 12, y: 10.34), controlPoint2: CGPoint(x: 13.34, y: 9))
        locationPath.addCurveToPoint(CGPoint(x: 18, y: 12), controlPoint1: CGPoint(x: 16.66, y: 9), controlPoint2: CGPoint(x: 18, y: 10.34))
        locationPath.addCurveToPoint(CGPoint(x: 15, y: 15), controlPoint1: CGPoint(x: 18, y: 13.66), controlPoint2: CGPoint(x: 16.66, y: 15))
        locationPath.closePath()
        locationPath.moveToPoint(CGPoint(x: 15, y: 3))
        locationPath.addCurveToPoint(CGPoint(x: 6, y: 12), controlPoint1: CGPoint(x: 9, y: 3), controlPoint2: CGPoint(x: 6, y: 7.5))
        locationPath.addCurveToPoint(CGPoint(x: 15, y: 27), controlPoint1: CGPoint(x: 6, y: 16.5), controlPoint2: CGPoint(x: 15, y: 27))
        locationPath.addCurveToPoint(CGPoint(x: 24, y: 12), controlPoint1: CGPoint(x: 15, y: 27), controlPoint2: CGPoint(x: 24, y: 16.5))
        locationPath.addCurveToPoint(CGPoint(x: 15, y: 3), controlPoint1: CGPoint(x: 24, y: 7.5), controlPoint2: CGPoint(x: 21, y: 3))
        locationPath.closePath()
        locationPath.miterLimit = 4
        
        locationPath.usesEvenOddFillRule = true
        
        fillColor.setFill()
        locationPath.fill()
    }
}
