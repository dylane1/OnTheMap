//
//  StarAnimationHolderView.swift
//  On The Map
//
//  Created by Dylan Edwards on 7/21/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

class StarAnimationHolderView: UIView {

    private let starLayer = CAShapeLayer()
    private let animationPath = SpiralAnimationPathLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.addSublayer(animationPath)
        
        configureStarLayer()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configuration
    
    private func configureStarLayer() {
        
        
        
        //TODO: Change color value
        starLayer.strokeColor   = Theme03.textLight.CGColor
        starLayer.fillColor     = starLayer.strokeColor
        
        let starPath = UIBezierPath()
        starPath.moveToPoint(CGPoint(x: 50, y: 0))
        starPath.addLineToPoint(CGPoint(x: 62.1, y: 33.35))
        starPath.addLineToPoint(CGPoint(x: 97.55, y: 34.55))
        starPath.addLineToPoint(CGPoint(x: 69.58, y: 56.36))
        starPath.addLineToPoint(CGPoint(x: 79.39, y: 90.45))
        starPath.addLineToPoint(CGPoint(x: 50, y: 70.58))
        starPath.addLineToPoint(CGPoint(x: 20.61, y: 90.45))
        starPath.addLineToPoint(CGPoint(x: 30.42, y: 56.36))
        starPath.addLineToPoint(CGPoint(x: 2.45, y: 34.55))
        starPath.addLineToPoint(CGPoint(x: 37.9, y: 33.35))
        starPath.closePath()
        
        starLayer.path = starPath.CGPath
        
        layer.addSublayer(starLayer)
    }
}
