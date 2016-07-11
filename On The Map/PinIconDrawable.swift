//
//  PinIconDrawable.swift
//  On The Map
//
//  Created by Dylan Edwards on 7/11/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

protocol PinIconDrawable { }

extension PinIconDrawable where Self: IconProviderProtocol {
    internal func draw32PointPinWithColor(fillColor: UIColor) {
        //// Symbolicons-Junior 2
        //// Pin Drawing
        let pinPath = UIBezierPath()
        pinPath.moveToPoint(CGPoint(x: 16, y: 10))
        pinPath.addCurveToPoint(CGPoint(x: 13.67, y: 7.75), controlPoint1: CGPoint(x: 14.71, y: 10), controlPoint2: CGPoint(x: 13.67, y: 8.99))
        pinPath.addCurveToPoint(CGPoint(x: 16, y: 5.5), controlPoint1: CGPoint(x: 13.67, y: 6.51), controlPoint2: CGPoint(x: 14.71, y: 5.5))
        pinPath.addCurveToPoint(CGPoint(x: 18.33, y: 7.75), controlPoint1: CGPoint(x: 17.29, y: 5.5), controlPoint2: CGPoint(x: 18.33, y: 6.51))
        pinPath.addCurveToPoint(CGPoint(x: 16, y: 10), controlPoint1: CGPoint(x: 18.33, y: 8.99), controlPoint2: CGPoint(x: 17.29, y: 10))
        pinPath.closePath()
        pinPath.moveToPoint(CGPoint(x: 16, y: 4))
        pinPath.addCurveToPoint(CGPoint(x: 9, y: 10.75), controlPoint1: CGPoint(x: 12.13, y: 4), controlPoint2: CGPoint(x: 9, y: 7.02))
        pinPath.addCurveToPoint(CGPoint(x: 16, y: 17.5), controlPoint1: CGPoint(x: 9, y: 14.48), controlPoint2: CGPoint(x: 12.13, y: 17.5))
        pinPath.addCurveToPoint(CGPoint(x: 23, y: 10.75), controlPoint1: CGPoint(x: 19.87, y: 17.5), controlPoint2: CGPoint(x: 23, y: 14.48))
        pinPath.addCurveToPoint(CGPoint(x: 16, y: 4), controlPoint1: CGPoint(x: 23, y: 7.02), controlPoint2: CGPoint(x: 19.87, y: 4))
        pinPath.closePath()
        pinPath.moveToPoint(CGPoint(x: 14.44, y: 18.86))
        pinPath.addLineToPoint(CGPoint(x: 14.44, y: 26.5))
        pinPath.addCurveToPoint(CGPoint(x: 16, y: 28), controlPoint1: CGPoint(x: 14.44, y: 27.33), controlPoint2: CGPoint(x: 15.14, y: 28))
        pinPath.addCurveToPoint(CGPoint(x: 17.56, y: 26.5), controlPoint1: CGPoint(x: 16.86, y: 28), controlPoint2: CGPoint(x: 17.56, y: 27.33))
        pinPath.addLineToPoint(CGPoint(x: 17.56, y: 18.86))
        pinPath.addCurveToPoint(CGPoint(x: 16, y: 19), controlPoint1: CGPoint(x: 17.05, y: 18.95), controlPoint2: CGPoint(x: 16.53, y: 19))
        pinPath.addCurveToPoint(CGPoint(x: 14.44, y: 18.86), controlPoint1: CGPoint(x: 15.47, y: 19), controlPoint2: CGPoint(x: 14.95, y: 18.95))
        pinPath.closePath()
        pinPath.miterLimit = 4;
        
        pinPath.usesEvenOddFillRule = true;
        
        fillColor.setFill()
        pinPath.fill()
    }
}
