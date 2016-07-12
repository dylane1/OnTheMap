//
// Copyright 2014 Dylan Edwards
//
//
/*******************************************************************************
* I'm just going to make this always come in to the center, and always leave from
* the center. If I need to  animate a view to some other spot on the screen, I’ll 
* need to use something else (or rewrite this class to something more elaborate).
*
*******************************************************************************/
import UIKit

final class BouncyViewControllerAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    private var inFromPosition: Position?
    private var inDirection: DirectionCP? /** Could be coming upZ or downZ */
    private var outToPosition: Position?
    private var outDirection: DirectionCP? /** Could be leaving upZ or downZ */
    
    private override init(){
        super.init()
//        magic(" ----------------------------> \(self.description) is initialized")
    }
    
    convenience init(withFromPosition fromPosition: Position, inDirection: DirectionCP? = nil) {
        /** Presenting view */
        magic("")
        self.init()
        if (fromPosition == .Center && (inDirection != .UpZ || inDirection != .DownZ)){
            fatalError("Animation from center must come in either from the top (shrink) or the bottom (expand)")
        }
        self.inFromPosition = fromPosition
        
        /** If fromPosition is not center, just ignore inDirection */
        self.inDirection    = (fromPosition == .Center) ? inDirection : nil
    }
    convenience init(withToPosition toPosition: Position, outDirection: DirectionCP? = nil) {
        /** Dismissing view */
        magic("")
        self.init()
        if (toPosition == .Center && (outDirection != .UpZ || outDirection != .DownZ)){
            fatalError("Animation to center must go out either to the top (expand) or the bottom (shrink)")
        }
        self.outToPosition  = toPosition
        
        /** If toPosition is not center, just ignore outDirection */
        self.outDirection   = (toPosition == .Center) ? outDirection : nil
        
    }
    //
    deinit { magic("\(self.description) is being deinitialized   <----------------") }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.8
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let presentedView = transitionContext.viewForKey(UITransitionContextToViewKey) else {
            fatalError("Error setting up presentedView in BouncyViewControllerAnimator")
        }
        
        let center = presentedView.center
        var destinationCenter = center
        
        //TODO: Make sure rotation doesn't reveal the hidden view
        if inFromPosition != nil {
            /** Presenting view */
            
            /** No need to alter destinationCenter */
            switch inFromPosition! {
            case .Top:
                presentedView.center = CGPointMake(center.x, -presentedView.bounds.size.height)
            case .Bottom:
                presentedView.center = CGPointMake(center.x, +presentedView.bounds.size.height)
            case .Left:
                presentedView.center = CGPointMake(center.y, -presentedView.bounds.size.width)
            case .Right:
                presentedView.center = CGPointMake(center.y, +presentedView.bounds.size.width)
            default: /** Center */
                break
            }
        } else if outToPosition != nil {
            /** Dismissing view */
            switch outToPosition! {
            case .Top:
                destinationCenter = CGPointMake(center.x, -presentedView.bounds.size.height)
            case .Bottom:
                destinationCenter = CGPointMake(center.x, +presentedView.bounds.size.height)
            case .Left:
                destinationCenter = CGPointMake(center.y, -presentedView.bounds.size.width)
            case .Right:
                destinationCenter = CGPointMake(center.y, +presentedView.bounds.size.width)
            default: /** Center */
                break
            }
        }
        
        
        transitionContext.containerView()!.addSubview(presentedView)
        
        UIView.animateWithDuration(
            transitionDuration(transitionContext),
            delay: 0,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 10.0,
            options: [],
            animations: {
                presentedView.center = destinationCenter
            },
            completion: { _ in
                transitionContext.completeTransition(true)
        })
    }
}
