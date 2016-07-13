//
//  TransitionOutAnimator.swift
//  On The Map
//
//  Created by Dylan Edwards on 7/11/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

final class TransitionOutAnimator : NSObject, UIViewControllerAnimatedTransitioning {
    
    private var duration: Double!
    private var toPosition: Position = .Bottom
    private var useScale: Bool = false
    private var fadeOutAlpha: Bool = false
    
    private override init() {
        super.init()
    }
    
    required convenience init(withDuration time: Double, toPosition position: Position = .Bottom, useScale scale: Bool = false, fadeOutAlpha alpha: Bool = false) {
        
        self.init()
        
        duration        = time
        toPosition      = position
        useScale        = scale
        fadeOutAlpha    = alpha
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return NSTimeInterval(duration)
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let presentedViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        
        let presentedView = presentedViewController.view
        let containerView = transitionContext.containerView()
        
        let center = presentedView.center
        var destinationCenter = center
        
        if toPosition != .Center {
            switch toPosition {
            case .Top:
                destinationCenter = CGPointMake(center.x, (-containerView!.bounds.size.height - presentedView.bounds.size.height))
            case .Bottom:
                destinationCenter = CGPointMake(center.x, (containerView!.bounds.size.height + presentedView.bounds.size.height))
            case .Left:
                destinationCenter = CGPointMake(center.y, (-containerView!.bounds.size.width - presentedView.bounds.size.width))
            case .Right:
                destinationCenter = CGPointMake(center.y, (containerView!.bounds.size.width + presentedView.bounds.size.width))
            default: /** Center */
                break
            }
        }

        let animationDuration = self .transitionDuration(transitionContext)
        
        UIView.animateWithDuration(animationDuration, animations: { () -> Void in
            magic("presentedView.center: \(presentedView.center); destinationCenter: \(destinationCenter)")
            presentedView.center = destinationCenter
            
            if self.useScale {
                presentedView.transform = CGAffineTransformMakeScale(0.1, 0.1)
            }
            if self.fadeOutAlpha {
                presentedView.alpha = 0.0
            }
            
        }) { (finished) -> Void in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }
}
