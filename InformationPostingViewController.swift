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
    private var activityIndicatorTransitioningDelegate: OverlayTransitioningDelegate?
    
    //MARK: - View Lifecycle
//    deinit { magic("\(self.description) is being deinitialized   <----------------") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = LocalizedStrings.ViewControllerTitles.enterYourLocation
        
        let navController = navigationController! as! NavigationController
        navController.setNavigationBarAttributes(isAppTitle: false)
        
        activityIndicatorTransitioningDelegate = OverlayTransitioningDelegate()
        
        let presentActivityIndicator = { [unowned self] (completion: (() -> Void)?) in
            self.presentActivityIndicator(
                self.getActivityIndicatorViewController(),
                transitioningDelegate: self.activityIndicatorTransitioningDelegate!,
                completion: completion)
        }
        
        let dismissActivityIndicator = { [unowned self] in
            self.dismissActivityIndicator(completion: nil)
        }
        
        let presentErrorAlert = getAlertPresentation()
        
        let submitSuccessfulClosure = { [unowned self] in
            let dismissalCompletion = { [unowned self] in
                /// Dismiss Me
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            self.dismissActivityIndicator(completion: dismissalCompletion)
        }
        
        postingView = view as! InformationPostingView
        
        postingView.configure(
            withActivityIndicatorPresentation: presentActivityIndicator,
            activityIndicatorDismissal: dismissActivityIndicator,
            successClosure: submitSuccessfulClosure,
            alertPresentationClosure: presentErrorAlert)
        
        configureNavigationItems()
    }
}
