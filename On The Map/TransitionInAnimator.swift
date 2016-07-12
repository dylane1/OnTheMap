//
//  TransitionInAnimator.swift
//  On The Map
//
//  Created by Dylan Edwards on 7/11/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

/**
 This is very informative:
 http://ericasadun.com/2015/10/19/sets-vs-dictionaries-smackdown-in-swiftlang/

 I was hoping to implement a dictionary of options like the NSAttributedString
 attribute dictionary.
 
 Unfortunately as of 2016-07-12 I haven't figured out how to use this correctly
 and I need to finish the project. I'll need to come back to it later.
**/
//enum TransitionInOptions: String {
//    case TransitionInFromPosition
//    case TransitionInUseScale
//    case TransitionInCornerRadius
//    case TransitionInShadowColor
//    case TransitionInFadeInAlpha
//    case TransitionInSpringDampening
//    case TransitionInSpringVelocity
//}
//enum TransitionInOptions {
//    case TransitionInFromPosition(Position)
//    case TransitionInUseScale(Bool)
//    case TransitionInCornerRadius(CGFloat)
//    case TransitionInShadowColor(UIColor)
//    case TransitionInFadeInAlpha(Bool)
//    case TransitionInSpringDampening(CGFloat)
//    case TransitionInSpringVelocity(CGFloat)
//}
//
//extension TransitionInOptions: Hashable, Equatable {
//    var hashValue: Int {
//        switch self {
//        case .TransitionInFromPosition: return 1
//        case .TransitionInUseScale: return 2
//        case .TransitionInCornerRadius: return 3
//        case .TransitionInShadowColor: return 4
//        case .TransitionInFadeInAlpha: return 5
//        case .TransitionInSpringDampening: return 6
//        case .TransitionInSpringVelocity: return 7
//        }
//    }
//}
//func ==(lhs: TransitionInOptions, rhs: TransitionInOptions) -> Bool {
//    return lhs.hashValue == rhs.hashValue
//}

final class TransitionInAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    /** 
     Making default behavior in from bottom like Apple does
     **/
    
    /// Required
    private var duration: Double!
    
    /// Optional
    
//    private var transitionOptions: Set<TransitionInOptions>?
//    private var transitionOptions: [String : AnyObject]?
    
    private var fromPosition: Position?
    private var useScale: Bool!
    private var cornerRadius: CGFloat!
    private var shadowColor: UIColor?
    private var fadeInAlpha: Bool!
    private var springDampening: CGFloat!
    private var springVelocity: CGFloat!
    
    
    private override init() {
        super.init()
    }
    
    required convenience init(
        withDuration time: Double,
        fromPosition position: Position     = .Bottom,
        useScale scale: Bool                = false,
        cornerRadius corners: CGFloat       = 0.0,
        shadowColor shadow: UIColor?        = nil,
        fadeInAlpha alpha: Bool             = false,
        springDampening dampening: CGFloat  = 0.0,
        springVelocity velocity: CGFloat    = 0.0) {
        
        self.init()
        
        duration        = time
        
//        transitionOptions = [.TransitionInFromPosition : .Bottom ]
        
        useScale        = scale
        cornerRadius    = corners
        shadowColor     = shadow
        fadeInAlpha     = alpha
        springDampening = dampening
        springVelocity  = velocity
    }

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return NSTimeInterval(duration)
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)! as UIViewController
        let containerView = transitionContext.containerView()
        
        let animationDuration = self .transitionDuration(transitionContext)
        
        toViewController.view.transform = CGAffineTransformMakeScale(0.1, 0.1)
        
//        if fromPosition != nil {
//            let center = presentedView.center
//            switch fromPosition! {
//            case .Top:
//                presentedView.center = CGPointMake(center.x, -presentedView.bounds.size.height)
//            case .Bottom:
//                presentedView.center = CGPointMake(center.x, +presentedView.bounds.size.height)
//            case .Left:
//                presentedView.center = CGPointMake(center.y, -presentedView.bounds.size.width)
//            case .Right:
//                presentedView.center = CGPointMake(center.y, +presentedView.bounds.size.width)
//            default: /** Center */
//                break
//            }
//        }
        
        
        if shadowColor != nil {
            toViewController.view.layer.shadowColor = UIColor.blackColor().CGColor
            toViewController.view.layer.shadowOffset = CGSizeMake(0.0, 2.0)
            toViewController.view.layer.shadowOpacity = 0.3
        }
        
        toViewController.view.layer.cornerRadius = cornerRadius
        toViewController.view.clipsToBounds = true
        
        containerView!.addSubview(toViewController.view)
        
        UIView.animateWithDuration(animationDuration,
                                   delay: 0,
                                   usingSpringWithDamping: springDampening,
                                   initialSpringVelocity: springVelocity,
                                   options: [],
                                   animations: { () -> Void in
            toViewController.view.transform = CGAffineTransformIdentity
            }, completion: { (finished) -> Void in
                transitionContext.completeTransition(finished)
        })
    }
}