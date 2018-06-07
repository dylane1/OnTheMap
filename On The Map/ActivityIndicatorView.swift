//
//  ActivityIndicatorView.swift
//  On The Map
//
//  Created by Dylan Edwards on 7/25/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

class ActivityIndicatorView: UIView {
    
    let ovalShapeLayer0 = CAShapeLayer()
    let ovalShapeLayer1 = CAShapeLayer()
    
    //MARK: - View Lifecycle
    
    override func didMoveToWindow() {
        configureIndicator()
        beginAnimating()
    }
    
    //MARK: - Configuration
    
    fileprivate func configureIndicator() {
        let radius      = frame.size.height / 2
        let startAngle  = CGFloat(M_PI_2 * 3)
        let endAngle    = CGFloat(2.0 * M_PI + M_PI_2 * 3)
        let centerPoint = CGPoint(x: radius, y: radius)

        ovalShapeLayer0.strokeColor = Theme.activityIndicatorCircle0.cgColor
        ovalShapeLayer0.fillColor = UIColor.clear.cgColor
        ovalShapeLayer0.lineWidth = 6.0
        ovalShapeLayer0.lineDashPattern = [0,24]
        ovalShapeLayer0.lineCap = kCALineCapRound
        
        ovalShapeLayer0.path = UIBezierPath(arcCenter: centerPoint, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true).cgPath
        
        layer.addSublayer(ovalShapeLayer0)
        
        ovalShapeLayer1.strokeColor = Theme.activityIndicatorCircle1.cgColor
        ovalShapeLayer1.fillColor = UIColor.clear.cgColor
        ovalShapeLayer1.lineWidth = 12.0
        ovalShapeLayer1.lineDashPattern = [0,24]
        ovalShapeLayer1.lineCap = kCALineCapRound
        
        ovalShapeLayer1.path = UIBezierPath(arcCenter: centerPoint, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true).cgPath
        
        layer.insertSublayer(ovalShapeLayer1, at: 0)
    }
    
    //MARK: - 
    
    fileprivate func beginAnimating() {
        let strokeStartAnimation = CABasicAnimation(
            keyPath: "strokeStart")
        strokeStartAnimation.fromValue = -3.0
        strokeStartAnimation.toValue = 1.0
        
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = 0.0
        strokeEndAnimation.toValue = 1.0
        
        
        let strokeAnimationGroup = CAAnimationGroup()
        strokeAnimationGroup.duration = 1.5
        strokeAnimationGroup.repeatDuration = 500.0
        strokeAnimationGroup.animations = [strokeStartAnimation,
                                           strokeEndAnimation]
        ovalShapeLayer0.add(strokeAnimationGroup, forKey: nil)
        ovalShapeLayer1.add(strokeAnimationGroup, forKey: nil)
    }
}
