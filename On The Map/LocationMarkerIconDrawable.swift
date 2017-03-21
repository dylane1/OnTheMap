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
    static func drawLocationMarkerWithColor(fillColor color: UIColor = UIColor.black) {
        //// Symbolicons-Junior 2
        //// location Drawing
        let fillColor = color
        
        let locationPath = UIBezierPath()
        locationPath.move(to: CGPoint(x: 20, y: 21))
        locationPath.addCurve(to: CGPoint(x: 16, y: 17), controlPoint1: CGPoint(x: 17.79, y: 21), controlPoint2: CGPoint(x: 16, y: 19.21))
        locationPath.addCurve(to: CGPoint(x: 20, y: 13), controlPoint1: CGPoint(x: 16, y: 14.79), controlPoint2: CGPoint(x: 17.79, y: 13))
        locationPath.addCurve(to: CGPoint(x: 24, y: 17), controlPoint1: CGPoint(x: 22.21, y: 13), controlPoint2: CGPoint(x: 24, y: 14.79))
        locationPath.addCurve(to: CGPoint(x: 20, y: 21), controlPoint1: CGPoint(x: 24, y: 19.21), controlPoint2: CGPoint(x: 22.21, y: 21))
        locationPath.close()
        locationPath.move(to: CGPoint(x: 20, y: 5))
        locationPath.addCurve(to: CGPoint(x: 8, y: 17), controlPoint1: CGPoint(x: 12, y: 5), controlPoint2: CGPoint(x: 8, y: 11))
        locationPath.addCurve(to: CGPoint(x: 20, y: 37), controlPoint1: CGPoint(x: 8, y: 23), controlPoint2: CGPoint(x: 20, y: 37))
        locationPath.addCurve(to: CGPoint(x: 32, y: 17), controlPoint1: CGPoint(x: 20, y: 37), controlPoint2: CGPoint(x: 32, y: 23))
        locationPath.addCurve(to: CGPoint(x: 20, y: 5), controlPoint1: CGPoint(x: 32, y: 11), controlPoint2: CGPoint(x: 28, y: 5))
        locationPath.close()
        locationPath.miterLimit = 4
        
        locationPath.usesEvenOddFillRule = true
        
        fillColor.setFill()
        locationPath.fill()
    }
    
    static func draw30PointLocationMarkerWithColor(fillColor color: UIColor = UIColor.black) {
        let fillColor = color
        
        let locationPath = UIBezierPath()
        
        locationPath.move(to: CGPoint(x: 15, y: 15))
        locationPath.addCurve(to: CGPoint(x: 12, y: 12), controlPoint1: CGPoint(x: 13.34, y: 15), controlPoint2: CGPoint(x: 12, y: 13.66))
        locationPath.addCurve(to: CGPoint(x: 15, y: 9), controlPoint1: CGPoint(x: 12, y: 10.34), controlPoint2: CGPoint(x: 13.34, y: 9))
        locationPath.addCurve(to: CGPoint(x: 18, y: 12), controlPoint1: CGPoint(x: 16.66, y: 9), controlPoint2: CGPoint(x: 18, y: 10.34))
        locationPath.addCurve(to: CGPoint(x: 15, y: 15), controlPoint1: CGPoint(x: 18, y: 13.66), controlPoint2: CGPoint(x: 16.66, y: 15))
        locationPath.close()
        locationPath.move(to: CGPoint(x: 15, y: 3))
        locationPath.addCurve(to: CGPoint(x: 6, y: 12), controlPoint1: CGPoint(x: 9, y: 3), controlPoint2: CGPoint(x: 6, y: 7.5))
        locationPath.addCurve(to: CGPoint(x: 15, y: 27), controlPoint1: CGPoint(x: 6, y: 16.5), controlPoint2: CGPoint(x: 15, y: 27))
        locationPath.addCurve(to: CGPoint(x: 24, y: 12), controlPoint1: CGPoint(x: 15, y: 27), controlPoint2: CGPoint(x: 24, y: 16.5))
        locationPath.addCurve(to: CGPoint(x: 15, y: 3), controlPoint1: CGPoint(x: 24, y: 7.5), controlPoint2: CGPoint(x: 21, y: 3))
        locationPath.close()
        locationPath.miterLimit = 4
        
        locationPath.usesEvenOddFillRule = true
        
        fillColor.setFill()
        locationPath.fill()
    }
}
