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
    internal var activityIndicatorViewController: PrimaryActivityIndicatorViewController?
    
    //MARK: - View Lifecycle
    deinit { magic("being deinitialized   <----------------") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = LocalizedStrings.ViewControllerTitles.enterYourLocation
        
        let navController = navigationController! as! NavigationController
        navController.setNavigationBarAttributes(isAppTitle: false)
        
        let presentActivityIndicator = { [weak self] (completion: (() -> Void)?) in
            if self!.activityIndicatorViewController == nil {
                self!.activityIndicatorViewController = self!.getActivityIndicatorViewController()
                self!.presentActivityIndicator(self!.activityIndicatorViewController!, completion: completion)
            }
        }
        
        let dismissActivityIndicator = { [weak self] in
            if self!.activityIndicatorViewController != nil {
                self!.dismissActivityIndicator(self!.activityIndicatorViewController!, completion: {
                    self!.activityIndicatorViewController = nil
                })
            }
        }
        
        let submitSuccessfulClosure = { [weak self] in
            let dismissalCompletion = { [weak self] in
                /// Dismiss Me
                self!.dismissViewControllerAnimated(true, completion: nil)
            }
            self!.dismissActivityIndicator(self!.activityIndicatorViewController!, completion: dismissalCompletion)
        }
        
        let presentErrorAlert = { [weak self] (parameters: AlertParameters) in
            let dismissalCompletion = { [weak self] in
                self!.activityIndicatorViewController = nil
                self!.presentAlertWithParameters(parameters)
            }
            self!.dismissActivityIndicator(self!.activityIndicatorViewController!, completion: dismissalCompletion)
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
