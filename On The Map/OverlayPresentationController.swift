//
// Copyright 2014 Dylan Edwards
//


import UIKit

final class OverlayPresentationController: UIPresentationController {
    
    private var dimmingView: UIView!
    private var dimmingBGColor: UIColor!
    private var contentSize: CGSize!
    private var tapToDismiss = false
    private var presentationComplete: (() -> Void)?
    private var dismissalCompletion: (() -> Void)?
    
    //MARK: - View Lifecycle
    
    private override init( presentedViewController: UIViewController, presentingViewController: UIViewController) {
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
        
//        println(" ----------------------------> \(self.description) is initialized init(coder)")
    }
    deinit { magic("\(self.description) is being deinitialized   <----------------") }
    
    required convenience init(
        presentedViewController: UIViewController,
        presentingViewController: UIViewController,
        preferredContentSize: CGSize,
        dimmingBGColor bgColor: UIColor = UIColor(white: 0.0, alpha: 0.5),
        tapToDismiss tap: Bool = false,
        dismissalCompletion completion: (() -> Void)? = nil) {
        
        self.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)

        contentSize         = preferredContentSize
        dimmingBGColor      = bgColor
        dismissalCompletion = completion
        tapToDismiss        = tap
    }
    
    //MARK: - Configuration
    
    func setupDimmingView() {
        dimmingView = UIView()
        
        dimmingView.backgroundColor = dimmingBGColor
        dimmingView.alpha           = 0.0
        dimmingView.frame           = containerView!.bounds

        if tapToDismiss {
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(OverlayPresentationController.dimmingViewTapped(_:)))
            dimmingView.addGestureRecognizer(tapRecognizer)
        }
    }
    
    func dimmingViewTapped(tapRecognizer: UITapGestureRecognizer) {
        presentingViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func presentationTransitionWillBegin() {
        setupDimmingView()
        
        
//        if doFadeInAlpha! {
//            presentedViewController.view.alpha = 0.0
//        }

        presentedViewController.preferredContentSize = contentSize
        containerView!.insertSubview(dimmingView, atIndex: 0)
        
        presentedViewController.transitionCoordinator()?.animateAlongsideTransition( { [weak self] context in
            self!.dimmingView.alpha = 1.0
//            if self!.doFadeInAlpha! {
//                self!.presentedViewController.view.alpha = 1.0
//            }
            }, completion: { [weak self] context in
                self!.presentationComplete?()
            })
        
    }
    
    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator()?.animateAlongsideTransition({ [weak self] context in
            self!.dimmingView.alpha = 0.0
        }, completion: { [weak self] context in
            self!.dimmingView.removeFromSuperview()
            self!.dismissalCompletion?()
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
