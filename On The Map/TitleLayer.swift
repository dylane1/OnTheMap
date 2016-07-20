//
//  TitleLayer.swift
//  On The Map
//
//  Created by Dylan Edwards on 7/20/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

//enum PhoneType {
//    case iPhone4s
//    case iPhone5
//    case iPhone6
//    case iPhone6P
//}
class TitleLayer: CAShapeLayer {
    private var fromValue: CGPath!
    
    private var path320x480Start: UIBezierPath {
        return Title320.path480Start()
    }
    
    private var path320x568Start: UIBezierPath {
        return Title320.path568Start()
    }
    
    private var path320Finish: UIBezierPath {
        return Title320.pathFinish()
    }
    override init() {
        super.init()
        fillColor = Theme03.textLight.CGColor// Colors.red.CGColor
        
        switch UIScreen.mainScreen().bounds.height {
        case 480:
            path = path320x480Start.CGPath
        case 568:
            path = path320x568Start.CGPath
        case 667:
            break
        case 736:
            break
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
        animation.fromValue = fromValue
        animation.toValue = path320Finish.CGPath
        animation.duration = duration
        animation.fillMode = kCAFillModeForwards
        animation.removedOnCompletion = false
        addAnimation(animation, forKey: nil)
    }
}
