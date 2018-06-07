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
    static func draw30PointMapWithColor(fillColor color: UIColor = UIColor.black) {
        //// Symbolicons-Junior 2
        //// Map Drawing
        let fillColor = color
        
        let mapPath = UIBezierPath()
        mapPath.move(to: CGPoint(x: 9.75, y: 29))
        mapPath.addLine(to: CGPoint(x: 20.25, y: 25.86))
        mapPath.addLine(to: CGPoint(x: 20.25, y: 1))
        mapPath.addLine(to: CGPoint(x: 9.75, y: 4.26))
        mapPath.addLine(to: CGPoint(x: 9.75, y: 29))
        mapPath.addLine(to: CGPoint(x: 9.75, y: 29))
        mapPath.close()
        mapPath.move(to: CGPoint(x: 1, y: 2.49))
        mapPath.addLine(to: CGPoint(x: 1, y: 22.58))
        mapPath.addCurve(to: CGPoint(x: 2.58, y: 25.11), controlPoint1: CGPoint(x: 1, y: 23.56), controlPoint2: CGPoint(x: 1.71, y: 24.7))
        mapPath.addLine(to: CGPoint(x: 8, y: 28.05))
        mapPath.addLine(to: CGPoint(x: 8, y: 3.54))
        mapPath.addLine(to: CGPoint(x: 2.64, y: 1.33))
        mapPath.addCurve(to: CGPoint(x: 1, y: 2.49), controlPoint1: CGPoint(x: 1.74, y: 1), controlPoint2: CGPoint(x: 1, y: 1.52))
        mapPath.addLine(to: CGPoint(x: 1, y: 2.49))
        mapPath.addLine(to: CGPoint(x: 1, y: 2.49))
        mapPath.close()
        mapPath.move(to: CGPoint(x: 27.44, y: 3.97))
        mapPath.addLine(to: CGPoint(x: 22, y: 1.18))
        mapPath.addLine(to: CGPoint(x: 22, y: 25.96))
        mapPath.addLine(to: CGPoint(x: 27.4, y: 28.28))
        mapPath.addCurve(to: CGPoint(x: 29, y: 27.23), controlPoint1: CGPoint(x: 28.28, y: 28.68), controlPoint2: CGPoint(x: 29, y: 28.21))
        mapPath.addLine(to: CGPoint(x: 29, y: 6.53))
        mapPath.addCurve(to: CGPoint(x: 27.44, y: 3.97), controlPoint1: CGPoint(x: 29, y: 5.56), controlPoint2: CGPoint(x: 28.3, y: 4.41))
        mapPath.addLine(to: CGPoint(x: 27.44, y: 3.97))
        mapPath.addLine(to: CGPoint(x: 27.44, y: 3.97))
        mapPath.close()
        mapPath.miterLimit = 4;
        
        mapPath.usesEvenOddFillRule = true;
        
        fillColor.setFill()
        mapPath.fill()
    }
}
