//
// Copyright 2014 Dylan Edwards
//

import UIKit

final class OverlayTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    private var preferredContentSize:   CGSize!
    private var cornerRadius:           CGFloat!
    private var dimmingBGColor:         UIColor!
    //TODO: Do I even need to worry about alpha? I should probably always transition alpha
    private var doFadeInAlpha:          Bool!
    
    private var inFromPosition: Position?
    private var inDirection:    Direction? /** Could be coming upZ or downZ */
    private var outToPosition:  Position?
    private var outDirection:   Direction? /** Could be leaving upZ or downZ */
    
    private override init() {
        super.init()
    }
    
    required convenience init(
        withPreferredContentSize preferredContentSize: CGSize,
        cornerRadius:   CGFloat     = 12.0,
        dimmingBGColor: UIColor     = UIColor(white: 0.0, alpha: 0.5),
        doFadeInAlpha:  Bool        = true,
        inFromPosition: Position    = .Top,
        inDirection:    Direction?  = nil,
        outToPosition:  Position    = .Bottom,
        outDirection:   Direction?  = nil)
    {
        //TODO: a bunch of checks here for valid input...
        //TODO:  How do I do a fool-proof init()? HOw do I force valid paramerters?
        self.init()
        
        self.preferredContentSize   = preferredContentSize
        self.cornerRadius           = cornerRadius
        self.dimmingBGColor         = dimmingBGColor
        self.doFadeInAlpha          = doFadeInAlpha
        
        /** in/out */
        //TODO: Don't want to bounce a transition on the z axis
    }
    
    func presentationControllerForPresentedViewController(
        presented: UIViewController,
        presentingViewController presenting: UIViewController,
        sourceViewController source: UIViewController) -> UIPresentationController?
    {
        return OverlayPresentationController(
            presentedViewController:    presented,
            presentingViewController:   presenting,
            cornerRadius:               cornerRadius,
            preferredContentSize:       preferredContentSize,
            dimmingBGColor:             dimmingBGColor,
            doFadeInAlpha:              doFadeInAlpha)
    }
  
    func animationControllerForPresentedController(
        presented:                          UIViewController,
        presentingController presenting:    UIViewController,
        sourceController source:            UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        return BouncyViewControllerAnimator(withFromPosition: .Top)
    }
  
}


//MARK: - UIViewControllerTransitioningDelegate methods

//    func presentationControllerForPresentedViewController(presented: UIViewController!, presentingViewController presenting: UIViewController!, sourceViewController source: UIViewController!) -> UIPresentationController! {
//        println("TPC: presentationControllerForPresentedViewController")
//        if presented == self {
//            return CustomPresentationController(presentedViewController: presented, presentingViewController: presenting)
//        }
//
//        return nil
//    }
//
//    func animationControllerForPresentedController(presented: UIViewController!, presentingController presenting: UIViewController!, sourceController source: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
//        println("TPC: animationControllerForPresentedController")
//        if presented == self {
//            return CustomPresentationAnimationController(isPresenting: true)
//        }
//        else {
//            return nil
//        }
//    }
//
    func animationControllerForDismissedController(dismissed: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        return BouncyViewControllerAnimator(withToPosition: .Bottom)
    }






