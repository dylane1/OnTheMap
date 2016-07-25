//
//  CircleMaskLayer.swift
//  On The Map
//
//  Created by Dylan Edwards on 7/20/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit
//import QuartzCore

class CircleMaskLayer: CAShapeLayer {
    
    private var circlePathStart: UIBezierPath {
        return UIBezierPath(ovalInRect: CGRect(x: Constants.screenWidth / 2, y: Constants.screenHeight / 2, width: 0.0, height: 0.0))
    }
    
    private var circlePathFinish: UIBezierPath {
        return UIBezierPath(ovalInRect: CGRect(x: 0, y: Constants.screenHeight / 2 - Constants.screenWidth / 2, width: Constants.screenWidth, height: Constants.screenWidth))
    }
    
    private var rectanglePathFull: UIBezierPath {
        let rectanglePath = UIBezierPath()
        rectanglePath.moveToPoint(CGPoint(x: 0.0, y: 0.0))
        rectanglePath.addLineToPoint(CGPoint(x: 0.0, y: 0.0))
        rectanglePath.addLineToPoint(CGPoint(x: Constants.screenWidth, y: 0.0))
        rectanglePath.addLineToPoint(CGPoint(x: Constants.screenWidth, y: Constants.screenHeight))
        rectanglePath.addLineToPoint(CGPoint(x: 0.0, y: Constants.screenHeight))
        rectanglePath.closePath()
        return rectanglePath
    }
    
    override init() {
        super.init()
        fillColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0).CGColor
        path = circlePathStart.CGPath
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func expandWithDuration(duration: CFTimeInterval) {
        magic("")
        let expandAnimation0 = CABasicAnimation(keyPath: "path")
        expandAnimation0.fromValue = circlePathStart.CGPath
        expandAnimation0.toValue = circlePathFinish.CGPath
        expandAnimation0.duration = duration
        
        let expandAnimation1 = CABasicAnimation(keyPath: "path")
        expandAnimation1.fromValue = circlePathStart.CGPath
        expandAnimation1.toValue = rectanglePathFull.CGPath
        expandAnimation1.beginTime = duration
        expandAnimation1.duration = 0.01
        
        let expandGroup = CAAnimationGroup()
        expandGroup.animations = [expandAnimation0, expandAnimation1]
        expandGroup.duration = expandAnimation1.beginTime + expandAnimation1.duration
        expandGroup.fillMode = kCAFillModeForwards
        expandGroup.removedOnCompletion = false
        
        addAnimation(expandGroup, forKey: nil)
    }
}
