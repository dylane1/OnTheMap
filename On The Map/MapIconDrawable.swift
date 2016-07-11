//
//  MapIconDrawable.swift
//  On The Map
//
//  Created by Dylan Edwards on 7/11/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

protocol MapIconDrawable { }

extension MapIconDrawable where Self: IconProviderProtocol {
    func draw30PointMapWithColor(fillColor: UIColor) {
        //// Symbolicons-Junior 2
        //// Map Drawing
        let mapPath = UIBezierPath()
        mapPath.moveToPoint(CGPoint(x: 9.75, y: 29))
        mapPath.addLineToPoint(CGPoint(x: 20.25, y: 25.86))
        mapPath.addLineToPoint(CGPoint(x: 20.25, y: 1))
        mapPath.addLineToPoint(CGPoint(x: 9.75, y: 4.26))
        mapPath.addLineToPoint(CGPoint(x: 9.75, y: 29))
        mapPath.addLineToPoint(CGPoint(x: 9.75, y: 29))
        mapPath.closePath()
        mapPath.moveToPoint(CGPoint(x: 1, y: 2.49))
        mapPath.addLineToPoint(CGPoint(x: 1, y: 22.58))
        mapPath.addCurveToPoint(CGPoint(x: 2.58, y: 25.11), controlPoint1: CGPoint(x: 1, y: 23.56), controlPoint2: CGPoint(x: 1.71, y: 24.7))
        mapPath.addLineToPoint(CGPoint(x: 8, y: 28.05))
        mapPath.addLineToPoint(CGPoint(x: 8, y: 3.54))
        mapPath.addLineToPoint(CGPoint(x: 2.64, y: 1.33))
        mapPath.addCurveToPoint(CGPoint(x: 1, y: 2.49), controlPoint1: CGPoint(x: 1.74, y: 1), controlPoint2: CGPoint(x: 1, y: 1.52))
        mapPath.addLineToPoint(CGPoint(x: 1, y: 2.49))
        mapPath.addLineToPoint(CGPoint(x: 1, y: 2.49))
        mapPath.closePath()
        mapPath.moveToPoint(CGPoint(x: 27.44, y: 3.97))
        mapPath.addLineToPoint(CGPoint(x: 22, y: 1.18))
        mapPath.addLineToPoint(CGPoint(x: 22, y: 25.96))
        mapPath.addLineToPoint(CGPoint(x: 27.4, y: 28.28))
        mapPath.addCurveToPoint(CGPoint(x: 29, y: 27.23), controlPoint1: CGPoint(x: 28.28, y: 28.68), controlPoint2: CGPoint(x: 29, y: 28.21))
        mapPath.addLineToPoint(CGPoint(x: 29, y: 6.53))
        mapPath.addCurveToPoint(CGPoint(x: 27.44, y: 3.97), controlPoint1: CGPoint(x: 29, y: 5.56), controlPoint2: CGPoint(x: 28.3, y: 4.41))
        mapPath.addLineToPoint(CGPoint(x: 27.44, y: 3.97))
        mapPath.addLineToPoint(CGPoint(x: 27.44, y: 3.97))
        mapPath.closePath()
        mapPath.miterLimit = 4;
        
        mapPath.usesEvenOddFillRule = true;
        
        fillColor.setFill()
        mapPath.fill()
    }
}
