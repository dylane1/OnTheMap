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
    static func draw32PointPinWithColor(fillColor color: UIColor = UIColor.black) {
        //// Symbolicons-Junior 2
        //// Pin Drawing
        let fillColor = color
        
        let pinPath = UIBezierPath()
        pinPath.move(to: CGPoint(x: 16, y: 10))
        pinPath.addCurve(to: CGPoint(x: 13.67, y: 7.75), controlPoint1: CGPoint(x: 14.71, y: 10), controlPoint2: CGPoint(x: 13.67, y: 8.99))
        pinPath.addCurve(to: CGPoint(x: 16, y: 5.5), controlPoint1: CGPoint(x: 13.67, y: 6.51), controlPoint2: CGPoint(x: 14.71, y: 5.5))
        pinPath.addCurve(to: CGPoint(x: 18.33, y: 7.75), controlPoint1: CGPoint(x: 17.29, y: 5.5), controlPoint2: CGPoint(x: 18.33, y: 6.51))
        pinPath.addCurve(to: CGPoint(x: 16, y: 10), controlPoint1: CGPoint(x: 18.33, y: 8.99), controlPoint2: CGPoint(x: 17.29, y: 10))
        pinPath.close()
        pinPath.move(to: CGPoint(x: 16, y: 4))
        pinPath.addCurve(to: CGPoint(x: 9, y: 10.75), controlPoint1: CGPoint(x: 12.13, y: 4), controlPoint2: CGPoint(x: 9, y: 7.02))
        pinPath.addCurve(to: CGPoint(x: 16, y: 17.5), controlPoint1: CGPoint(x: 9, y: 14.48), controlPoint2: CGPoint(x: 12.13, y: 17.5))
        pinPath.addCurve(to: CGPoint(x: 23, y: 10.75), controlPoint1: CGPoint(x: 19.87, y: 17.5), controlPoint2: CGPoint(x: 23, y: 14.48))
        pinPath.addCurve(to: CGPoint(x: 16, y: 4), controlPoint1: CGPoint(x: 23, y: 7.02), controlPoint2: CGPoint(x: 19.87, y: 4))
        pinPath.close()
        pinPath.move(to: CGPoint(x: 14.44, y: 18.86))
        pinPath.addLine(to: CGPoint(x: 14.44, y: 26.5))
        pinPath.addCurve(to: CGPoint(x: 16, y: 28), controlPoint1: CGPoint(x: 14.44, y: 27.33), controlPoint2: CGPoint(x: 15.14, y: 28))
        pinPath.addCurve(to: CGPoint(x: 17.56, y: 26.5), controlPoint1: CGPoint(x: 16.86, y: 28), controlPoint2: CGPoint(x: 17.56, y: 27.33))
        pinPath.addLine(to: CGPoint(x: 17.56, y: 18.86))
        pinPath.addCurve(to: CGPoint(x: 16, y: 19), controlPoint1: CGPoint(x: 17.05, y: 18.95), controlPoint2: CGPoint(x: 16.53, y: 19))
        pinPath.addCurve(to: CGPoint(x: 14.44, y: 18.86), controlPoint1: CGPoint(x: 15.47, y: 19), controlPoint2: CGPoint(x: 14.95, y: 18.95))
        pinPath.close()
        pinPath.miterLimit = 4;
        
        pinPath.usesEvenOddFillRule = true;
        
        fillColor.setFill()
        pinPath.fill()
    }
}
