//
//  TitleAnimationHolderView.swift
//  On The Map
//
//  Created by Dylan Edwards on 7/20/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

class TitleAnimationHolderView: UIView {
    
    let titleLayer = TitleLayer()
    let maskLayer = CAShapeLayer()
    let circleLayer = CircleMaskLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
        magic("frame: \(frame)")
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
    }
    
    override func didMoveToWindow() {
        layer.addSublayer(titleLayer)
        titleLayer.mask = circleLayer
    }

    
    //MARK: - 
    
    internal func revealTitle(withClosure closure: () -> Void) {
        
        circleLayer.expandWithDuration(0.3)
        
        let popTime0 = dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double(NSEC_PER_SEC)))
        
        dispatch_after(popTime0, dispatch_get_main_queue()) {
            self.animateTitle()
        }
        
        let popTime1 = dispatch_time(DISPATCH_TIME_NOW, Int64(0.6 * Double(NSEC_PER_SEC)))
        
        dispatch_after(popTime1, dispatch_get_main_queue()) {
            /// Kick off the other animations
            closure()
        }
    }
    
    private func animateTitle() {
        /** 
         Note, this doesn't actually get done in that time, there must be a
         big performance hit when animating complex bezier paths. I could probably
         get much better performace by animating rastered images, but then the
         blur from scaling is an issue. Slightly slow, but crisp is better than
         fast but blurred...
         */
        titleLayer.animateWithDuration(0.3)
    }
}