//
//  InformationPostingViewController.swift
//  On The Map
//
//  Created by Dylan Edwards on 6/9/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

class InformationPostingViewController: UIViewController, InformationPostingNavigationProtocol, AlertPresentable, ActivityIndicatorPresentable {
    
    private var presentActivityIndicator: (() -> Void)!
    private var dismissActivityIndicator: (() -> Void)!
    private var postingView: InformationPostingView!
    
    //MARK: - View Lifecycle
    deinit { magic("being deinitialized   <----------------") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = LocalizedStrings.ViewControllerTitles.enterYourLocation
        
        let navController = navigationController! as! NavigationController
        navController.setNavigationBarAttributes(isAppTitle: false)
        
        presentActivityIndicator = { [weak self] in
            magic("Present!")
            let activityIndicatorVC = self!.getActivityIndicatorViewController()
            
            /**
             Make extension UIViewController
             presentActivityIndicator(activityIndicatorInstance, animated: completion:)
             */
            self!.presentViewController(activityIndicatorVC, animated: false, completion: nil)
        }
        
        dismissActivityIndicator = { [weak self] in
            magic("Dismiss!")
            self!.dismissViewControllerAnimated(false, completion: nil)
        }
        
        configureView()
        configureNavigationItems()
    }
    
    //MARK: - Configuration
    
    private func configureView() {
        postingView = view as! InformationPostingView
        
        let submitSuccessfulClosure = { [weak self] in
            /// Dismiss Activity Indicator
            self!.dismissViewControllerAnimated(true, completion: {
                /// Dismiss Me
                self!.dismissViewControllerAnimated(true, completion: nil)
            })

        }
        
        postingView.configure(
            withSuccessClosure: submitSuccessfulClosure,
            activityIndicatorPresentationClosure: presentActivityIndicator,
            dissmissActivityIndicatorClosure: dismissActivityIndicator,
            alertPresentationClosure: getAlertPresentationClosure())
    }
}
