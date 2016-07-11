//
// Copyright 2014 Dylan Edwards
//


import UIKit

final class OverlayPresentationController: UIPresentationController {
    
    private let dimmingView = UIView()
    
    private var dimmingBGColor: UIColor!
    private var doFadeInAlpha:  Bool!
    private var contentSize:    CGSize! //WTF? why can't I set preferredContentSized? THis isn't a UIViewController!
    
    private override init(
        presentedViewController:    UIViewController,
        presentingViewController:   UIViewController)
    {
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
//        println(" ----------------------------> \(self.description) is initialized init(coder)")
    }
//    deinit { println("\(self.description) is being deinitialized   <----------------") }
    
    required convenience init(
        presentedViewController:    UIViewController,
        presentingViewController:   UIViewController,
        cornerRadius:               CGFloat,
        preferredContentSize:       CGSize,
        dimmingBGColor:             UIColor = UIColor(white: 0.0, alpha: 0.5),
        doFadeInAlpha:              Bool    = true)
    {
        self.init(presentedViewController: presentedViewController,presentingViewController: presentingViewController)
        
        presentedViewController.view.cornerRadius   = CGFloat(cornerRadius)
        self.contentSize                            = preferredContentSize
        self.dimmingView.backgroundColor            = dimmingBGColor
        self.doFadeInAlpha                          = doFadeInAlpha
    }
    
    override func presentationTransitionWillBegin() {
        dimmingView.frame = containerView!.bounds
        dimmingView.alpha = 0.0
        if doFadeInAlpha! {
            presentedViewController.view.alpha = 0.0
        }
//        magic("presentedViewController: \(presentedViewController)")
        presentedViewController.preferredContentSize = contentSize
        containerView!.insertSubview(dimmingView, atIndex: 0)
        
        //TODO: WTF is 'context' in here? Why is it here?
        presentedViewController.transitionCoordinator()?.animateAlongsideTransition( { [weak self] context in
            self!.dimmingView.alpha = 1.0
            if self!.doFadeInAlpha! {
                self!.presentedViewController.view.alpha = 1.0
            }
        }, completion: nil)
        
    }
    
    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator()?.animateAlongsideTransition({ [weak self] context in
            self!.dimmingView.alpha = 0.0
        }, completion: { [weak self] context in
            self!.dimmingView.removeFromSuperview()
        })
    }
    
    override func frameOfPresentedViewInContainerView() -> CGRect {
        if presentedViewController.preferredContentSize.width > 0 {
            let x = containerView!.center.x - presentedViewController.preferredContentSize.width / 2
            let y = containerView!.center.y - presentedViewController.preferredContentSize.height / 2
            return CGRect(x: x, y: y, width: presentedViewController.preferredContentSize.width, height: presentedViewController.preferredContentSize.height)
        } else {
            return containerView!.bounds.insetBy(dx: 0, dy: 0)
        }
    }
    
    override func containerViewWillLayoutSubviews() {
        dimmingView.frame = containerView!.bounds
        presentedView()!.frame = frameOfPresentedViewInContainerView()
    }
}
