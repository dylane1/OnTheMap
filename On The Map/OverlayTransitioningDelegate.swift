//
// Copyright 2014 Dylan Edwards
//

import UIKit

enum Position {
    case Top, Bottom, Left, Right, Center
}

/// Dictionary Keys
enum TransitionInOption {
    case AlphaIn /// Bool
    case AlphaOut /// Bool
    case CornerRadius /// CGFloat
    case DimmingBGColor /// UIColor
    case DurationIn /// Double
    case DurationOut /// Double
    case InFromPosition /// Position
    case OutToPosition /// Position
    case ScaleIn /// Bool
    case ScaleOut /// Bool
    case ShadowColor /// UIColor
    case SpringDampening /// CGFloat
    case SpringVelocity /// CGFloat
    case TapToDismiss /// Bool
}


final class OverlayTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    private var options: [TransitionInOption : Any]?
    
    /** OverlayPresentationController **/
    private var preferredContentSize: CGSize!
    private var dimmingBGColor              = UIColor(white: 0.0, alpha: 0.5)
    private var tapToDismiss                = false
    private var dismissalCompletion: (() -> Void)?
    
    /** TransitionInAnimator **/
    private var durationIn: Double          = 0.5
    private var fromPosition: Position      = .Bottom
    private var useScaleIn                  = false
    private var cornerRadius: CGFloat       = 0.0
    private var shadowColor: UIColor?
    private var fadeInAlpha                 = false
    private var springDampening: CGFloat    = 1.0
    private var springVelocity: CGFloat     = 0.0
    
    /** TransitionOutAnimator **/
    private var durationOut: Double         = 0.5
    private var outToPosition: Position     = .Bottom
    private var useScaleOut: Bool           = false
    private var fadeOutAlpha: Bool          = false
    
    
    private override init() {
        super.init()
    }
    
    required convenience init(
        withPreferredContentSize contentSize: CGSize,
        dismissalCompletion outComplete: (() -> Void)? = nil,
        options opts: [TransitionInOption : Any]? = nil) {
        
        self.init()
        
        preferredContentSize    = contentSize
        dismissalCompletion     = outComplete
        options = opts
        
        checkForOptions()
    }
    
    private func checkForOptions() {
        guard let options = options else { return }
        
        /** OverlayPresentationController **/
        
        if let bgDimming = options[.DimmingBGColor] as? UIColor {
            dimmingBGColor = bgDimming
        }
        if let tapDissmiss = options[.TapToDismiss] as? Bool {
            tapToDismiss = tapDissmiss
        }
        
        /** TransitionInAnimator **/
        
        if let timeIn = options[.DurationIn] as? Double {
            durationIn = timeIn
        }
        if let inFrom = options[.InFromPosition] as? Position {
            fromPosition = inFrom
        }
        if let scaleIn = options[.ScaleIn] as? Bool {
            useScaleIn = scaleIn
        }
        if let corners = options[.CornerRadius] as? CGFloat {
            cornerRadius = corners
        }
        if let shadow = options[.ShadowColor] as? UIColor {
            shadowColor = shadow
        }
        if let alphaIn = options[.AlphaIn] as? Bool {
            fadeInAlpha = alphaIn
        }
        if let dampening = options[.SpringDampening] as? CGFloat {
            springDampening = dampening
        }
        if let velocity = options[.SpringVelocity] as? CGFloat {
            springVelocity = velocity
        }
        
        /** TransitionOutAnimator **/
        
        if let timeOut = options[.DurationOut] as? Double {
            durationIn = timeOut
        }
        if let outTo = options[.OutToPosition] as? Position {
            outToPosition = outTo
        }
        if let scaleOut = options[.ScaleOut] as? Bool {
            useScaleOut = scaleOut
        }
        if let alphaOut = options[.AlphaOut] as? Bool {
            fadeOutAlpha = alphaOut
        }
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




















