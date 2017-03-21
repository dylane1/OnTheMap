//
//  SpiralAnimationPath.swift
//  On The Map
//
//  Created by Dylan Edwards on 7/21/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

class SpiralAnimationPathLayer: CAShapeLayer {
    
    fileprivate var spiralPath: UIBezierPath {
        let bezierPath: UIBezierPath!
        
        switch Constants.screenHeight {
        case Constants.DeviceScreenHeight.iPhone4s:
            bezierPath = path320x480
        case Constants.DeviceScreenHeight.iPhone5:
            bezierPath = path320x568
        case Constants.DeviceScreenHeight.iPhone6:
            bezierPath = path375x667
        default:
            /// iPhone6Plus
            bezierPath = path414x736
        }
        
        return bezierPath
    }
    
    
    fileprivate var path320x480: UIBezierPath {
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: frame.minX + 76, y: frame.minY + 382))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 280, y: frame.minY + 222), controlPoint1: CGPoint(x: frame.minX + 76, y: frame.minY + 382), controlPoint2: CGPoint(x: frame.minX + 280, y: frame.minY + 399))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 160, y: frame.minY + 98), controlPoint1: CGPoint(x: frame.minX + 279.5, y: frame.minY + 89.5), controlPoint2: CGPoint(x: frame.minX + 160, y: frame.minY + 98))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 40, y: frame.minY + 222), controlPoint1: CGPoint(x: frame.minX + 160, y: frame.minY + 98), controlPoint2: CGPoint(x: frame.minX + 40, y: frame.minY + 96))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 160, y: frame.minY + 222), controlPoint1: CGPoint(x: frame.minX + 40, y: frame.minY + 348), controlPoint2: CGPoint(x: frame.minX + 207.5, y: frame.minY + 325.5))
        
        return bezierPath
    }
    
    fileprivate var path320x568: UIBezierPath {
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: frame.minX + 76, y: frame.minY + 426))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 280, y: frame.minY + 266), controlPoint1: CGPoint(x: frame.minX + 76, y: frame.minY + 426), controlPoint2: CGPoint(x: frame.minX + 280, y: frame.minY + 443))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 160, y: frame.minY + 142), controlPoint1: CGPoint(x: frame.minX + 279.5, y: frame.minY + 133.5), controlPoint2: CGPoint(x: frame.minX + 160, y: frame.minY + 142))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 40, y: frame.minY + 266), controlPoint1: CGPoint(x: frame.minX + 160, y: frame.minY + 142), controlPoint2: CGPoint(x: frame.minX + 40, y: frame.minY + 140))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 160, y: frame.minY + 266), controlPoint1: CGPoint(x: frame.minX + 40, y: frame.minY + 392), controlPoint2: CGPoint(x: frame.minX + 207.5, y: frame.minY + 369.5))
        
        return bezierPath
    }
    
    fileprivate var path375x667: UIBezierPath {
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: frame.minX + 83.35, y: frame.minY + 509.95))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 337.5, y: frame.minY + 310.34), controlPoint1: CGPoint(x: frame.minX + 83.35, y: frame.minY + 509.95), controlPoint2: CGPoint(x: frame.minX + 337.5, y: frame.minY + 531.16))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 188, y: frame.minY + 155.64), controlPoint1: CGPoint(x: frame.minX + 336.88, y: frame.minY + 145.03), controlPoint2: CGPoint(x: frame.minX + 188, y: frame.minY + 155.64))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 38.5, y: frame.minY + 310.34), controlPoint1: CGPoint(x: frame.minX + 188, y: frame.minY + 155.64), controlPoint2: CGPoint(x: frame.minX + 38.5, y: frame.minY + 153.14))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 188, y: frame.minY + 310.34), controlPoint1: CGPoint(x: frame.minX + 38.5, y: frame.minY + 467.53), controlPoint2: CGPoint(x: frame.minX + 247.18, y: frame.minY + 439.46))
        
        return bezierPath
    }
    
    fileprivate var path414x736: UIBezierPath {
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: frame.minX + 89.05, y: frame.minY + 566.88))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 375.5, y: frame.minY + 341.96), controlPoint1: CGPoint(x: frame.minX + 89.05, y: frame.minY + 566.88), controlPoint2: CGPoint(x: frame.minX + 375.5, y: frame.minY + 590.78))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 207, y: frame.minY + 167.65), controlPoint1: CGPoint(x: frame.minX + 374.8, y: frame.minY + 155.71), controlPoint2: CGPoint(x: frame.minX + 207, y: frame.minY + 167.65))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 38.5, y: frame.minY + 341.96), controlPoint1: CGPoint(x: frame.minX + 207, y: frame.minY + 167.65), controlPoint2: CGPoint(x: frame.minX + 38.5, y: frame.minY + 164.84))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 207, y: frame.minY + 341.96), controlPoint1: CGPoint(x: frame.minX + 38.5, y: frame.minY + 519.08), controlPoint2: CGPoint(x: frame.minX + 273.7, y: frame.minY + 487.46))
        
        return bezierPath
    }
    
    fileprivate override init() {
        super.init()
        strokeColor = UIColor.clear.cgColor
        fillColor = UIColor.clear.cgColor
        lineWidth = 4.0
        lineDashPattern = [2, 3]
        
        path = spiralPath.cgPath
    }
    convenience init(withFrame frame: CGRect) {
        self.init()
        self.frame = frame
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
