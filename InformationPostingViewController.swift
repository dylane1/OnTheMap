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
    
    private var overlayTransitioningDelegate: OverlayTransitioningDelegate?
    
    //    deinit { magic("\(self.description) is being deinitialized   <----------------") }
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = LocalizedStrings.ViewControllerTitles.enterYourLocation
        
        let navController = navigationController! as! NavigationController
        navController.setNavigationBarAttributes(isAppTitle: false)
        
        let presentActivityIndicator = { (completion: (() -> Void)?) in
            self.overlayTransitioningDelegate = OverlayTransitioningDelegate()
            self.presentActivityIndicator(
                self.getActivityIndicatorViewController(),
                transitioningDelegate: self.overlayTransitioningDelegate!,
                completion: completion)
        }
        
        let dismissActivityIndicator = { /*[weak self]*/
            self.dismissActivityIndicator(completion: {
                self.overlayTransitioningDelegate = nil
            })
        }
        
        let presentErrorAlert = getAlertPresentation()
        
        let submitSuccessfulClosure = { /*[weak self]*/
            let dismissalCompletion = { /*[weak self]*/
                self.overlayTransitioningDelegate = nil
                
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
