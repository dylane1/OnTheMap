//
// Copyright 2014 Dylan Edwards
//

import UIKit

//TODO: Remove  Dimmable when done getting this working

enum Position {
    case Top, Bottom, Left, Right, Center
}

final class OverlayTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    /** OverlayPresentationController **/
    private var preferredContentSize: CGSize!
    private var dimmingBGColor: UIColor!
    private var tapToDismiss = false
    private var presentationCompletion: (() -> Void)?
    private var dismissalCompletion: (() -> Void)?
    
    /** TransitionInAnimator **/
    private var durationIn: Double!
    private var fromPosition: Position!
    private var useScaleIn = false
    private var cornerRadius: CGFloat!
    private var shadowColor: UIColor?
    private var fadeInAlpha = false
    private var springDampening: CGFloat!
    private var springVelocity: CGFloat!
    
    /** TransitionOutAnimator **/
    private var durationOut: Double!
    private var outToPosition: Position!
    private var useScaleOut: Bool = false
    private var fadeOutAlpha: Bool = false
    
    
    private override init() {
        super.init()
    }
    
    required convenience init(
        /** OverlayPresentationController **/
        withPreferredContentSize contentSize: CGSize,
        dimmingBGColor bgColor: UIColor                     = UIColor(white: 0.0, alpha: 0.5),
        tapBackgroundToDismiss tap: Bool                    = false,
        presentationCompletion inComplete: (() -> Void)?    = nil,
        dismissalCompletion outComplete: (() -> Void)?      = nil,
                            
        /** TransitionInAnimator **/
        durationIn timeIn: Double           = 0.5,
        fromPosition inFrom: Position       = .Bottom,
        useScaleIn scaleIn: Bool            = false,
        cornerRadius corners: CGFloat       = 0.0,
        shadowColor shadow: UIColor?        = nil,
        fadeInAlpha fadeIn: Bool            = false,
        springDampening dampening: CGFloat  = 1.0,
        springVelocity velocity: CGFloat    = 0.0,
        
        /** TransitionOutAnimator **/
        durationOut timeOut: Double     = 0.5,
        outToPosition outTo: Position   = .Bottom,
        useScaleOut scaleOut: Bool      = false,
        fadeOutAlpha fadeOut: Bool      = false) {
        
        self.init()
        
        /** OverlayPresentationController **/
        preferredContentSize    = contentSize
        dimmingBGColor          = bgColor
        tapToDismiss            = tap
        presentationCompletion  = inComplete
        dismissalCompletion     = outComplete
        
        /** TransitionInAnimator **/
        durationIn      = timeIn
        fromPosition    = inFrom
        useScaleIn      = scaleIn
        cornerRadius    = corners
        shadowColor     = shadow
        fadeInAlpha     = fadeIn
        springDampening = dampening
        springVelocity  = velocity
        
        /** TransitionOutAnimator **/
        durationOut     = timeOut
        outToPosition   = outTo
        useScaleOut     = scaleOut
        fadeOutAlpha    = fadeOut
    }
    
    func presentationControllerForPresentedViewController(
        presented: UIViewController,
        presentingViewController presenting: UIViewController,
        sourceViewController source: UIViewController) -> UIPresentationController? {
        
        return OverlayPresentationController(
            presentedViewController: presented,
            presentingViewController: presenting,
            preferredContentSize: preferredContentSize,
            dimmingBGColor: dimmingBGColor,
            tapToDismiss: tapToDismiss,
            dismissalCompletion: dismissalCompletion)
    }
  
    func animationControllerForPresentedController(
        presented: UIViewController,
        presentingController presenting: UIViewController,
        sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return TransitionInAnimator(
            withDuration: durationIn,
            fromPosition: fromPosition,
            useScale: useScaleIn,
            cornerRadius: cornerRadius,
            shadowColor: shadowColor,
            fadeInAlpha: fadeInAlpha,
            springDampening: springDampening,
            springVelocity: springVelocity)
    }
  
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TransitionOutAnimator(withDuration: durationOut, toPosition: outToPosition, useScale: useScaleOut, fadeOutAlpha: fadeOutAlpha)
    }
}




















