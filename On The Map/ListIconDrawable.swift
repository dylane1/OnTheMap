//
//  ListIconDrawable.swift
//  On The Map
//
//  Created by Dylan Edwards on 7/11/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

protocol ListIconDrawable { }

extension ListIconDrawable where Self: IconProviderProtocol {
    internal func draw30PointListWithColor(fillColor: UIColor) {
        //// Symbolicons-Junior 2
        //// List Drawing
        let listPath = UIBezierPath()
        listPath.moveToPoint(CGPoint(x: 3.81, y: 2))
        listPath.addCurveToPoint(CGPoint(x: 1, y: 4.88), controlPoint1: CGPoint(x: 2.26, y: 2), controlPoint2: CGPoint(x: 1, y: 3.29))
        listPath.addCurveToPoint(CGPoint(x: 3.81, y: 7.77), controlPoint1: CGPoint(x: 1, y: 6.48), controlPoint2: CGPoint(x: 2.26, y: 7.77))
        listPath.addCurveToPoint(CGPoint(x: 6.63, y: 4.88), controlPoint1: CGPoint(x: 5.37, y: 7.77), controlPoint2: CGPoint(x: 6.63, y: 6.48))
        listPath.addCurveToPoint(CGPoint(x: 3.81, y: 2), controlPoint1: CGPoint(x: 6.63, y: 3.29), controlPoint2: CGPoint(x: 5.37, y: 2))
        listPath.closePath()
        listPath.moveToPoint(CGPoint(x: 29.12, y: 12.58))
        listPath.addLineToPoint(CGPoint(x: 10.38, y: 12.58))
        listPath.addCurveToPoint(CGPoint(x: 8.5, y: 14.5), controlPoint1: CGPoint(x: 9.34, y: 12.58), controlPoint2: CGPoint(x: 8.5, y: 13.44))
        listPath.addCurveToPoint(CGPoint(x: 10.38, y: 16.42), controlPoint1: CGPoint(x: 8.5, y: 15.56), controlPoint2: CGPoint(x: 9.34, y: 16.42))
        listPath.addLineToPoint(CGPoint(x: 29.12, y: 16.42))
        listPath.addCurveToPoint(CGPoint(x: 31, y: 14.5), controlPoint1: CGPoint(x: 30.16, y: 16.42), controlPoint2: CGPoint(x: 31, y: 15.56))
        listPath.addCurveToPoint(CGPoint(x: 29.12, y: 12.58), controlPoint1: CGPoint(x: 31, y: 13.44), controlPoint2: CGPoint(x: 30.16, y: 12.58))
        listPath.closePath()
        listPath.moveToPoint(CGPoint(x: 29.12, y: 22.19))
        listPath.addLineToPoint(CGPoint(x: 10.38, y: 22.19))
        listPath.addCurveToPoint(CGPoint(x: 8.5, y: 24.12), controlPoint1: CGPoint(x: 9.34, y: 22.19), controlPoint2: CGPoint(x: 8.5, y: 23.05))
        listPath.addCurveToPoint(CGPoint(x: 10.38, y: 26.04), controlPoint1: CGPoint(x: 8.5, y: 25.18), controlPoint2: CGPoint(x: 9.34, y: 26.04))
        listPath.addLineToPoint(CGPoint(x: 29.12, y: 26.04))
        listPath.addCurveToPoint(CGPoint(x: 31, y: 24.12), controlPoint1: CGPoint(x: 30.16, y: 26.04), controlPoint2: CGPoint(x: 31, y: 25.18))
        listPath.addCurveToPoint(CGPoint(x: 29.12, y: 22.19), controlPoint1: CGPoint(x: 31, y: 23.05), controlPoint2: CGPoint(x: 30.16, y: 22.19))
        listPath.closePath()
        listPath.moveToPoint(CGPoint(x: 10.38, y: 6.81))
        listPath.addLineToPoint(CGPoint(x: 29.12, y: 6.81))
        listPath.addCurveToPoint(CGPoint(x: 31, y: 4.88), controlPoint1: CGPoint(x: 30.16, y: 6.81), controlPoint2: CGPoint(x: 31, y: 5.95))
        listPath.addCurveToPoint(CGPoint(x: 29.12, y: 2.96), controlPoint1: CGPoint(x: 31, y: 3.82), controlPoint2: CGPoint(x: 30.16, y: 2.96))
        listPath.addLineToPoint(CGPoint(x: 10.38, y: 2.96))
        listPath.addCurveToPoint(CGPoint(x: 8.5, y: 4.88), controlPoint1: CGPoint(x: 9.34, y: 2.96), controlPoint2: CGPoint(x: 8.5, y: 3.82))
        listPath.addCurveToPoint(CGPoint(x: 10.38, y: 6.81), controlPoint1: CGPoint(x: 8.5, y: 5.95), controlPoint2: CGPoint(x: 9.34, y: 6.81))
        listPath.closePath()
        listPath.moveToPoint(CGPoint(x: 3.81, y: 21.23))
        listPath.addCurveToPoint(CGPoint(x: 1, y: 24.12), controlPoint1: CGPoint(x: 2.26, y: 21.23), controlPoint2: CGPoint(x: 1, y: 22.52))
        listPath.addCurveToPoint(CGPoint(x: 3.81, y: 27), controlPoint1: CGPoint(x: 1, y: 25.71), controlPoint2: CGPoint(x: 2.26, y: 27))
        listPath.addCurveToPoint(CGPoint(x: 6.63, y: 24.12), controlPoint1: CGPoint(x: 5.37, y: 27), controlPoint2: CGPoint(x: 6.63, y: 25.71))
        listPath.addCurveToPoint(CGPoint(x: 3.81, y: 21.23), controlPoint1: CGPoint(x: 6.63, y: 22.52), controlPoint2: CGPoint(x: 5.37, y: 21.23))
        listPath.closePath()
        listPath.moveToPoint(CGPoint(x: 3.81, y: 11.62))
        listPath.addCurveToPoint(CGPoint(x: 1, y: 14.5), controlPoint1: CGPoint(x: 2.26, y: 11.62), controlPoint2: CGPoint(x: 1, y: 12.91))
        listPath.addCurveToPoint(CGPoint(x: 3.81, y: 17.38), controlPoint1: CGPoint(x: 1, y: 16.09), controlPoint2: CGPoint(x: 2.26, y: 17.38))
        listPath.addCurveToPoint(CGPoint(x: 6.63, y: 14.5), controlPoint1: CGPoint(x: 5.37, y: 17.38), controlPoint2: CGPoint(x: 6.63, y: 16.09))
        listPath.addCurveToPoint(CGPoint(x: 3.81, y: 11.62), controlPoint1: CGPoint(x: 6.63, y: 12.91), controlPoint2: CGPoint(x: 5.37, y: 11.62))
        listPath.closePath()
        listPath.miterLimit = 4;
        
        listPath.usesEvenOddFillRule = true;
        
        fillColor.setFill()
        listPath.fill()
    }
}
