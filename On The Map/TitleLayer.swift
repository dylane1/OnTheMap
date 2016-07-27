//
//  TitleLayer.swift
//  On The Map
//
//  Created by Dylan Edwards on 7/20/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

class TitleLayer: CAShapeLayer {
    private var fromValue: CGPath!
    private var toValue: CGPath!

    override init() {
        super.init()
        fillColor = Theme.textLight.CGColor
        
        switch Constants.screenHeight {
        case Constants.DeviceScreenHeight.iPhone4s:
            path = Title480And568h.path480Start().CGPath
            toValue = Title480And568h.pathFinish().CGPath
        case Constants.DeviceScreenHeight.iPhone5:
            path = Title480And568h.path568Start().CGPath
            toValue = Title480And568h.pathFinish().CGPath
        case Constants.DeviceScreenHeight.iPhone6:
            path = Title667h.pathStart().CGPath
            toValue = Title667h.pathFinish().CGPath
        case Constants.DeviceScreenHeight.iPhone6Plus:
            path = Title736h.pathStart().CGPath
            toValue = Title736h.pathFinish().CGPath
        default:
            break
        }
        fromValue = path
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func animateWithDuration(duration: CFTimeInterval) {
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "path")
        animation.fromValue             = fromValue
        animation.toValue               = toValue
        animation.duration              = duration
        animation.fillMode              = kCAFillModeForwards
        animation.removedOnCompletion   = false
        
        addAnimation(animation, forKey: nil)
    }
}
