//
//  NavigateRightIconDrawable.swift
//  On The Map
//
//  Created by Dylan Edwards on 7/12/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

protocol NavigateRightIconDrawable { }

extension NavigateRightIconDrawable where Self: IconProviderProtocol {
    internal func draw30PointNavigationRightWithColor(fillColor: UIColor) {
        //// Symbolicons-Junior
        //// navigate-right Drawing
        let navigaterightPath = UIBezierPath()
        navigaterightPath.moveToPoint(CGPoint(x: 10.75, y: 2.77))
        navigaterightPath.addCurveToPoint(CGPoint(x: 8.78, y: 2), controlPoint1: CGPoint(x: 10.21, y: 2.26), controlPoint2: CGPoint(x: 9.49, y: 2))
        navigaterightPath.addCurveToPoint(CGPoint(x: 6.82, y: 2.77), controlPoint1: CGPoint(x: 8.07, y: 2), controlPoint2: CGPoint(x: 7.36, y: 2.26))
        navigaterightPath.addCurveToPoint(CGPoint(x: 6.82, y: 6.48), controlPoint1: CGPoint(x: 5.73, y: 3.79), controlPoint2: CGPoint(x: 5.73, y: 5.46))
        navigaterightPath.addLineToPoint(CGPoint(x: 16.9, y: 16))
        navigaterightPath.addLineToPoint(CGPoint(x: 6.82, y: 25.52))
        navigaterightPath.addCurveToPoint(CGPoint(x: 6.82, y: 29.23), controlPoint1: CGPoint(x: 5.73, y: 26.54), controlPoint2: CGPoint(x: 5.73, y: 28.21))
        navigaterightPath.addCurveToPoint(CGPoint(x: 10.75, y: 29.23), controlPoint1: CGPoint(x: 7.9, y: 30.26), controlPoint2: CGPoint(x: 9.66, y: 30.26))
        navigaterightPath.addLineToPoint(CGPoint(x: 23.46, y: 17.24))
        navigaterightPath.addCurveToPoint(CGPoint(x: 23.46, y: 14.76), controlPoint1: CGPoint(x: 24.18, y: 16.56), controlPoint2: CGPoint(x: 24.18, y: 15.44))
        navigaterightPath.addLineToPoint(CGPoint(x: 10.75, y: 2.77))
        navigaterightPath.closePath()
        navigaterightPath.miterLimit = 4;
        
        navigaterightPath.usesEvenOddFillRule = true;
        
        fillColor.setFill()
        navigaterightPath.fill()
    }
}
