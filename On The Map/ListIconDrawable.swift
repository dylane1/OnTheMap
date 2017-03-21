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
    static func draw30PointListWithColor(fillColor color: UIColor = UIColor.black) {
        //// Symbolicons-Junior 2
        //// List Drawing
        let fillColor = color
        
        let listPath = UIBezierPath()
        listPath.move(to: CGPoint(x: 3.63, y: 3))
        listPath.addCurve(to: CGPoint(x: 1, y: 5.65), controlPoint1: CGPoint(x: 2.18, y: 3), controlPoint2: CGPoint(x: 1, y: 4.19))
        listPath.addCurve(to: CGPoint(x: 3.63, y: 8.31), controlPoint1: CGPoint(x: 1, y: 7.12), controlPoint2: CGPoint(x: 2.18, y: 8.31))
        listPath.addCurve(to: CGPoint(x: 6.25, y: 5.65), controlPoint1: CGPoint(x: 5.07, y: 8.31), controlPoint2: CGPoint(x: 6.25, y: 7.12))
        listPath.addCurve(to: CGPoint(x: 3.63, y: 3), controlPoint1: CGPoint(x: 6.25, y: 4.19), controlPoint2: CGPoint(x: 5.07, y: 3))
        listPath.close()
        listPath.move(to: CGPoint(x: 27.25, y: 12.73))
        listPath.addLine(to: CGPoint(x: 9.75, y: 12.73))
        listPath.addCurve(to: CGPoint(x: 8, y: 14.5), controlPoint1: CGPoint(x: 8.78, y: 12.73), controlPoint2: CGPoint(x: 8, y: 13.52))
        listPath.addCurve(to: CGPoint(x: 9.75, y: 16.27), controlPoint1: CGPoint(x: 8, y: 15.48), controlPoint2: CGPoint(x: 8.78, y: 16.27))
        listPath.addLine(to: CGPoint(x: 27.25, y: 16.27))
        listPath.addCurve(to: CGPoint(x: 29, y: 14.5), controlPoint1: CGPoint(x: 28.22, y: 16.27), controlPoint2: CGPoint(x: 29, y: 15.48))
        listPath.addCurve(to: CGPoint(x: 27.25, y: 12.73), controlPoint1: CGPoint(x: 29, y: 13.52), controlPoint2: CGPoint(x: 28.22, y: 12.73))
        listPath.close()
        listPath.move(to: CGPoint(x: 27.25, y: 21.58))
        listPath.addLine(to: CGPoint(x: 9.75, y: 21.58))
        listPath.addCurve(to: CGPoint(x: 8, y: 23.35), controlPoint1: CGPoint(x: 8.78, y: 21.58), controlPoint2: CGPoint(x: 8, y: 22.37))
        listPath.addCurve(to: CGPoint(x: 9.75, y: 25.12), controlPoint1: CGPoint(x: 8, y: 24.32), controlPoint2: CGPoint(x: 8.78, y: 25.12))
        listPath.addLine(to: CGPoint(x: 27.25, y: 25.12))
        listPath.addCurve(to: CGPoint(x: 29, y: 23.35), controlPoint1: CGPoint(x: 28.22, y: 25.12), controlPoint2: CGPoint(x: 29, y: 24.32))
        listPath.addCurve(to: CGPoint(x: 27.25, y: 21.58), controlPoint1: CGPoint(x: 29, y: 22.37), controlPoint2: CGPoint(x: 28.22, y: 21.58))
        listPath.close()
        listPath.move(to: CGPoint(x: 9.75, y: 7.42))
        listPath.addLine(to: CGPoint(x: 27.25, y: 7.42))
        listPath.addCurve(to: CGPoint(x: 29, y: 5.65), controlPoint1: CGPoint(x: 28.22, y: 7.42), controlPoint2: CGPoint(x: 29, y: 6.63))
        listPath.addCurve(to: CGPoint(x: 27.25, y: 3.88), controlPoint1: CGPoint(x: 29, y: 4.68), controlPoint2: CGPoint(x: 28.22, y: 3.88))
        listPath.addLine(to: CGPoint(x: 9.75, y: 3.88))
        listPath.addCurve(to: CGPoint(x: 8, y: 5.65), controlPoint1: CGPoint(x: 8.78, y: 3.88), controlPoint2: CGPoint(x: 8, y: 4.68))
        listPath.addCurve(to: CGPoint(x: 9.75, y: 7.42), controlPoint1: CGPoint(x: 8, y: 6.63), controlPoint2: CGPoint(x: 8.78, y: 7.42))
        listPath.close()
        listPath.move(to: CGPoint(x: 3.63, y: 20.69))
        listPath.addCurve(to: CGPoint(x: 1, y: 23.35), controlPoint1: CGPoint(x: 2.18, y: 20.69), controlPoint2: CGPoint(x: 1, y: 21.88))
        listPath.addCurve(to: CGPoint(x: 3.63, y: 26), controlPoint1: CGPoint(x: 1, y: 24.81), controlPoint2: CGPoint(x: 2.18, y: 26))
        listPath.addCurve(to: CGPoint(x: 6.25, y: 23.35), controlPoint1: CGPoint(x: 5.07, y: 26), controlPoint2: CGPoint(x: 6.25, y: 24.81))
        listPath.addCurve(to: CGPoint(x: 3.63, y: 20.69), controlPoint1: CGPoint(x: 6.25, y: 21.88), controlPoint2: CGPoint(x: 5.07, y: 20.69))
        listPath.close()
        listPath.move(to: CGPoint(x: 3.63, y: 11.85))
        listPath.addCurve(to: CGPoint(x: 1, y: 14.5), controlPoint1: CGPoint(x: 2.18, y: 11.85), controlPoint2: CGPoint(x: 1, y: 13.04))
        listPath.addCurve(to: CGPoint(x: 3.63, y: 17.15), controlPoint1: CGPoint(x: 1, y: 15.96), controlPoint2: CGPoint(x: 2.18, y: 17.15))
        listPath.addCurve(to: CGPoint(x: 6.25, y: 14.5), controlPoint1: CGPoint(x: 5.07, y: 17.15), controlPoint2: CGPoint(x: 6.25, y: 15.96))
        listPath.addCurve(to: CGPoint(x: 3.63, y: 11.85), controlPoint1: CGPoint(x: 6.25, y: 13.04), controlPoint2: CGPoint(x: 5.07, y: 11.85))
        listPath.close()
        listPath.miterLimit = 4;
        
        listPath.usesEvenOddFillRule = true;
        
        fillColor.setFill()
        listPath.fill()
    }
}
