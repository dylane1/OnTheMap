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


final class OverlayTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate /*OptionsHandlerType*/ {
    
//    enum Position: String {
//        case Top, Bottom, Left, Right, Center
//    }
    
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
        /** OverlayPresentationController **/
        withPreferredContentSize contentSize: CGSize,
//        dimmingBGColor bgColor: UIColor                     = UIColor(white: 0.0, alpha: 0.5),
//        tapBackgroundToDismiss tap: Bool                    = false,
        dismissalCompletion outComplete: (() -> Void)?      = nil,
                            
        /** TransitionInAnimator **/
//        durationIn timeIn: Double           = 0.5,
//        fromPosition inFrom: Position       = .Bottom,
//        useScaleIn scaleIn: Bool            = false,
//        cornerRadius corners: CGFloat       = 0.0,
//        shadowColor shadow: UIColor?        = nil,
//        fadeInAlpha fadeIn: Bool            = false,
//        springDampening dampening: CGFloat  = 1.0,
//        springVelocity velocity: CGFloat    = 0.0,
        
        /** TransitionOutAnimator **/
//        durationOut timeOut: Double     = 0.5,
//        outToPosition outTo: Position   = .Bottom,
//        useScaleOut scaleOut: Bool      = false,
//        fadeOutAlpha fadeOut: Bool      = false,
        options opts: [TransitionInOption : Any]? = nil) {
        
        self.init()
        
        /** OverlayPresentationController **/
        preferredContentSize    = contentSize
//        dimmingBGColor          = bgColor
//        tapToDismiss            = tap
        dismissalCompletion     = outComplete
        
        /** TransitionInAnimator **/
//        durationIn      = timeIn
//        fromPosition    = inFrom
//        useScaleIn      = scaleIn
//        cornerRadius    = corners
//        shadowColor     = shadow
//        fadeInAlpha     = fadeIn
//        springDampening = dampening
//        springVelocity  = velocity
        
        /** TransitionOutAnimator **/
//        durationOut     = timeOut
//        outToPosition   = outTo
//        useScaleOut     = scaleOut
//        fadeOutAlpha    = fadeOut
        options = opts
        
        checkForOptions()
    }
    
    private func checkForOptions() {
        guard let options = options else { return }
        
        if let inFrom = options[.InFromPosition] as? Position {
//            inFrom = Position(rawValue: inFromString) {
//            magic("inFrom: \(inFrom)")
            fromPosition = inFrom
        } else {
            magic("invalid position string sent")
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




















