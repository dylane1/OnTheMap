//
//  TitleAnimationHolderView.swift
//  On The Map
//
//  Created by Dylan Edwards on 7/20/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

class TitleAnimationHolderView: UIView {
    
    fileprivate let titleLayer = TitleLayer()
    fileprivate let maskLayer = CAShapeLayer()
    fileprivate let circleLayer = CircleMaskLayer()
    
    //MARK: - View Lifecycle
    
    override func didMoveToWindow() {
        backgroundColor = UIColor.clear
        layer.addSublayer(titleLayer)
        titleLayer.mask = circleLayer
    }
    
    //MARK: - 
    
    internal func revealTitle(withClosure closure: @escaping () -> Void) {
        
        circleLayer.expandWithDuration(0.3)
        
        let popTime0 = DispatchTime.now() + Double(Int64(0.3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: popTime0) {
            self.animateTitle()
        }
        
        let popTime1 = DispatchTime.now() + Double(Int64(0.6 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: popTime1) {
            /// Kick off the other animations
            closure()
        }
    }
    
    fileprivate func animateTitle() {
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
