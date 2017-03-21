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
    
    fileprivate var circlePathStart: UIBezierPath {
        return UIBezierPath(ovalIn: CGRect(x: Constants.screenWidth / 2, y: Constants.screenHeight / 2, width: 0.0, height: 0.0))
    }
    
    fileprivate var circlePathFinish: UIBezierPath {
        return UIBezierPath(ovalIn: CGRect(x: 0, y: Constants.screenHeight / 2 - Constants.screenWidth / 2, width: Constants.screenWidth, height: Constants.screenWidth))
    }
    
    fileprivate var rectanglePathFull: UIBezierPath {
        let rectanglePath = UIBezierPath()
        rectanglePath.move(to: CGPoint(x: 0.0, y: 0.0))
        rectanglePath.addLine(to: CGPoint(x: 0.0, y: 0.0))
        rectanglePath.addLine(to: CGPoint(x: Constants.screenWidth, y: 0.0))
        rectanglePath.addLine(to: CGPoint(x: Constants.screenWidth, y: Constants.screenHeight))
        rectanglePath.addLine(to: CGPoint(x: 0.0, y: Constants.screenHeight))
        rectanglePath.close()
        return rectanglePath
    }
    
    override init() {
        super.init()
        fillColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0).cgColor
        path = circlePathStart.cgPath
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func expandWithDuration(_ duration: CFTimeInterval) {
        
        let expandAnimation0 = CABasicAnimation(keyPath: "path")
        expandAnimation0.fromValue = circlePathStart.cgPath
        expandAnimation0.toValue = circlePathFinish.cgPath
        expandAnimation0.duration = duration
        
        let expandAnimation1 = CABasicAnimation(keyPath: "path")
        expandAnimation1.fromValue = circlePathStart.cgPath
        expandAnimation1.toValue = rectanglePathFull.cgPath
        expandAnimation1.beginTime = duration
        expandAnimation1.duration = 0.01
        
        let expandGroup = CAAnimationGroup()
        expandGroup.animations = [expandAnimation0, expandAnimation1]
        expandGroup.duration = expandAnimation1.beginTime + expandAnimation1.duration
        expandGroup.fillMode = kCAFillModeForwards
        expandGroup.isRemovedOnCompletion = false
        
        add(expandGroup, forKey: nil)
    }
}
