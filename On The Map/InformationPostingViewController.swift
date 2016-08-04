//
//  InformationPostingViewController.swift
//  On The Map
//
//  Created by Dylan Edwards on 6/9/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

class InformationPostingViewController: UIViewController, InformationPostingNavigationProtocol, AlertPresentable, ActivityIndicatorPresentable {
    
    private var postingView: InformationPostingView!
    
    /// ActivityIndicatorPresentable
    internal var activityIndicatorViewController: ActivityIndicatorViewController?
    internal var overlayTransitioningDelegate: OverlayTransitioningDelegate?
    internal var activityIndicatorIsPresented = false
    
//    deinit { magic("\(self.description) is being deinitialized   <----------------") }
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = LocalizedStrings.ViewControllerTitles.enterYourLocation
        
        let navController = navigationController! as! InformationPostingNavigationController
        navController.setNavigationBarAttributes(isAppTitle: false)
        
        overlayTransitioningDelegate = OverlayTransitioningDelegate()
        
        let presentActivityIndicator = { [weak self] (completion: (() -> Void)?) in
            self!.activityIndicatorViewController = self!.getActivityIndicatorViewController()
            self!.presentActivityIndicator(
                self!.activityIndicatorViewController!,
                transitioningDelegate: self!.overlayTransitioningDelegate!,
                completion: completion)
        }
        
        let dismissActivityIndicator = { [weak self] in
            self!.dismissActivityIndicator(completion: nil)
        }
        
        let presentErrorAlert = getAlertPresentation()
        
        let submitSuccessfulClosure = { [weak self] in
            let dismissalCompletion = { [weak self] in
                
                /// Fix memory leak...
                self!.overlayTransitioningDelegate = nil
                
                /// Dismiss Me
                self!.dismissViewControllerAnimated(true, completion: nil)
            }
            self!.dismissActivityIndicator(completion: dismissalCompletion)
        }
        
        postingView = view as! InformationPostingView
        
        postingView.configure(
            withActivityIndicatorPresentation: presentActivityIndicator,
            activityIndicatorDismissal: dismissActivityIndicator,
            successClosure: submitSuccessfulClosure,
            alertPresentationClosure: presentErrorAlert)
        
        configureNavigationItems()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        postingView = nil
    }
}
