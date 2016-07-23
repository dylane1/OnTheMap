//
//  SpiralAnimationPath.swift
//  On The Map
//
//  Created by Dylan Edwards on 7/21/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

class SpiralAnimationPathLayer: CAShapeLayer {
    private var spiralPath: UIBezierPath {
        let frame: CGRect = CGRect(x: 0, y: 80, width: 320, height: 400)
        
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPoint(x: frame.minX + 76, y: frame.minY + 360))
        bezierPath.addCurveToPoint(CGPoint(x: frame.minX + 280, y: frame.minY + 200), controlPoint1: CGPoint(x: frame.minX + 76, y: frame.minY + 360), controlPoint2: CGPoint(x: frame.minX + 280, y: frame.minY + 377))
        bezierPath.addCurveToPoint(CGPoint(x: frame.minX + 160, y: frame.minY + 76), controlPoint1: CGPoint(x: frame.minX + 279.5, y: frame.minY + 67.5), controlPoint2: CGPoint(x: frame.minX + 160, y: frame.minY + 76))
        bezierPath.addCurveToPoint(CGPoint(x: frame.minX + 40, y: frame.minY + 200), controlPoint1: CGPoint(x: frame.minX + 160, y: frame.minY + 76), controlPoint2: CGPoint(x: frame.minX + 40, y: frame.minY + 74))
        bezierPath.addCurveToPoint(CGPoint(x: frame.minX + 160, y: frame.minY + 200), controlPoint1: CGPoint(x: frame.minX + 40, y: frame.minY + 326), controlPoint2: CGPoint(x: frame.minX + 207.5, y: frame.minY + 303.5))
        UIColor.redColor().setStroke()
        bezierPath.lineWidth = 1
        bezierPath.stroke()
        
        return bezierPath
    }
    
    override init() {
        super.init()
        strokeColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0).CGColor
        fillColor = UIColor.clearColor().CGColor
        lineWidth = 4.0
        lineDashPattern = [2, 3]
        
        path = spiralPath.CGPath
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
