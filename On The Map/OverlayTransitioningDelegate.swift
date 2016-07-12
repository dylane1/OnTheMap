//
// Copyright 2014 Dylan Edwards
//

import UIKit

//TODO: Remove  Dimmable when done getting this working
enum DirectionCP {
    case Up, Down, Left, Right, UpZ, DownZ
}

enum Position {
    case Top, Bottom, Left, Right, Center
}

final class OverlayTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    private var preferredContentSize: CGSize!
    private var cornerRadius: CGFloat!
    private var dimmingBGColor: UIColor!
    private var fadeInAlpha = true
    private var tapToDismiss = false
    
    private var inFromPosition: Position!
    private var inDirection: DirectionCP? /** Could be coming upZ or downZ */
    private var outToPosition: Position!
    private var outDirection: DirectionCP? /** Could be leaving upZ or downZ */
    
    private var dismissalCompletion: (() -> Void)?
    
    private override init() {
        super.init()
    }
    
    required convenience init(
        withPreferredContentSize contentSize: CGSize,
        cornerRadius corners: CGFloat       = 0.0,
        dimmingBGColor bgColor: UIColor     = UIColor(white: 0.0, alpha: 0.5),
        fadeInAlpha fadeIn: Bool            = true,
        tapToDismiss tap: Bool              = false,
        inFromPosition inFrom: Position     = .Top,
        inDirection inDir: DirectionCP?     = nil,
        outToPosition outTo: Position       = .Bottom,
        outDirection outDir: DirectionCP?   = nil,
        dismissalCompletion outComplete: (() -> Void)?  = nil) {
        
        self.init()
        
        preferredContentSize    = contentSize
        cornerRadius            = corners
        dimmingBGColor          = bgColor
        fadeInAlpha             = fadeIn
        tapToDismiss            = tap
        inFromPosition          = inFrom
        inDirection             = inDir
        outToPosition           = outTo
        outDirection            = outDir
        dismissalCompletion     = outComplete
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
        
        return TransitionInAnimator(withDuration: 0.3, cornerRadius: cornerRadius, shadowColor: nil, fadeInAlpha: fadeInAlpha, springDampening: 0.5, springVelocity: 10.0)
//        return BouncyViewControllerAnimator(withFromPosition: inFromPosition)
    }
  
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TransitionOutAnimator(/*withToPosition: .Bottom*/)
    }
}







