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
            self!.presentActivityIndicator(withPresentationCompletion: nil/*, dismissalCompletion: completion*/)
        }
//        let presentActivityIndicator    = getActivityIndicatorPresentation()
        
        let dismissActivityIndicator = { [weak self] in
            self!.dismissActivityIndicator(withCompletion: nil)
        }
//        let dismissActivityIndicator    = getActivityIndicatorDismissal()
        let presentErrorAlert           = getAlertPresentation()
        
        let submitSuccessfulClosure = { [weak self] in
            let dismissalCompletion = { [weak self] in
                /// Dismiss Me
                self!.dismissViewControllerAnimated(true, completion: nil)
            }
            self!.dismissActivityIndicator(withCompletion: dismissalCompletion)
//            self!.dismissActivityIndicator(self!.activityIndicatorViewController!, completion: dismissalCompletion)
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
