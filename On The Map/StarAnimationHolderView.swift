//
//  StarAnimationHolderView.swift
//  On The Map
//
//  Created by Dylan Edwards on 7/21/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

class StarAnimationHolderView: UIView {

    private var starLayer = StarLayer()
    private var animationPath: SpiralAnimationPathLayer! //(withFrame: self.frame)
    
    private var duration: CFTimeInterval!
    
    //MARK: - View Lifecycle
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        backgroundColor = Theme.loginScreenBGGradient
        
        starLayer.position = CGPoint(x: -100, y: -100)
        
        animationPath = SpiralAnimationPathLayer(withFrame: frame)
    
        
        layer.addSublayer(animationPath)
        layer.addSublayer(starLayer)

        beginAnimating()
    }
    
    convenience init(withDuration duration: CFTimeInterval) {
        self.init()
        self.duration = duration
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    //MARK: -
    
    private func beginAnimating() {
        
        /// Path for Star
        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.fromValue = -0.5
        strokeStartAnimation.toValue = 1.0
        
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = 0.0
        strokeEndAnimation.toValue = 1.0
        
        let strokeAnimationGroup = CAAnimationGroup()
        strokeAnimationGroup.duration = duration
        strokeAnimationGroup.animations = [strokeStartAnimation, strokeEndAnimation]
        strokeAnimationGroup.fillMode = kCAFillModeForwards
        
        animationPath.addAnimation(strokeAnimationGroup, forKey: nil)
        
        /// Star
        let starAnimation = CAKeyframeAnimation(keyPath: "position")
        starAnimation.path = animationPath.path
        starAnimation.calculationMode = kCAAnimationPaced
        
        let scaleAnimation0 = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation0.fromValue = 0
        scaleAnimation0.toValue = 1
        scaleAnimation0.beginTime = 0
        scaleAnimation0.duration = strokeAnimationGroup.duration * 0.75
        
        let scaleAnimation1 = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation1.fromValue = 1
        scaleAnimation1.toValue = 0
        scaleAnimation1.beginTime = strokeAnimationGroup.duration * 0.75
        scaleAnimation1.duration = strokeAnimationGroup.duration * 0.25
        
        
        let starOrientationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        starOrientationAnimation.fromValue = 0
        starOrientationAnimation.toValue = 5 * M_PI
        
        
        let flightAnimationGroup = CAAnimationGroup()
        flightAnimationGroup.duration = duration
        flightAnimationGroup.animations = [starAnimation, scaleAnimation0, scaleAnimation1, starOrientationAnimation]
        flightAnimationGroup.fillMode = kCAFillModeForwards
        
        starLayer.addAnimation(flightAnimationGroup, forKey: nil)
    }
}
