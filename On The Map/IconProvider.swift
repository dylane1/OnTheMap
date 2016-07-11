//
//  IconProvider.swift
//  On The Map
//
//  Created by Dylan Edwards on 7/10/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//
/// Icon bezier drawing code generated in PaintCode

import UIKit

struct IconProvider { }

protocol Icons30PointRepresentable { }
protocol Icons32PointRepresentable { }

enum Icon: String {
    case Pin
    case Map
    case List
}

enum Size: CGFloat {
    case Thirty     = 30
    case ThirtyTwo  = 32
}

extension IconProvider {
    static func imageOfDrawnIcon(icon: Icon, size: Size, fillColor: UIColor) -> UIImage {
        var imageOfIcon: UIImage {
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.rawValue, size.rawValue), false, 0)
            
            switch icon {
            case .Pin:
                draw32PointPinWithColor(fillColor)
            case .Map:
                draw30PointMapWithColor(fillColor)
            case .List:
                draw30PointListWithColor(fillColor)
            }
            
            let img = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            
            return img
        }
        return imageOfIcon
    }
}

//MARK: - Icons30PointRepresentable

extension IconProvider: Icons30PointRepresentable {
    static func draw30PointMapWithColor(fillColor: UIColor) {
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
    
    static func draw30PointListWithColor(fillColor: UIColor) {
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

//MARK: - Icons32PointRepresentable

extension IconProvider: Icons32PointRepresentable {
    static func draw32PointPinWithColor(fillColor: UIColor) {
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
