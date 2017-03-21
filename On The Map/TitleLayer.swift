//
//  TitleLayer.swift
//  On The Map
//
//  Created by Dylan Edwards on 7/20/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

class TitleLayer: CAShapeLayer {
    fileprivate var fromValue: CGPath!
    fileprivate var toValue: CGPath!

    override init() {
        super.init()
        fillColor = Theme.textLight.cgColor
        
        switch Constants.screenHeight {
        case Constants.DeviceScreenHeight.iPhone4s:
            path = Title480And568h.path480Start().cgPath
            toValue = Title480And568h.pathFinish().cgPath
        case Constants.DeviceScreenHeight.iPhone5:
            path = Title480And568h.path568Start().cgPath
            toValue = Title480And568h.pathFinish().cgPath
        case Constants.DeviceScreenHeight.iPhone6:
            path = Title667h.pathStart().cgPath
            toValue = Title667h.pathFinish().cgPath
        case Constants.DeviceScreenHeight.iPhone6Plus:
            path = Title736h.pathStart().cgPath
            toValue = Title736h.pathFinish().cgPath
        default:
            break
        }
        fromValue = path
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func animateWithDuration(_ duration: CFTimeInterval) {
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "path")
        animation.fromValue             = fromValue
        animation.toValue               = toValue
        animation.duration              = duration
        animation.fillMode              = kCAFillModeForwards
        animation.isRemovedOnCompletion   = false
        
        add(animation, forKey: nil)
    }
}
