//
//  LoginViewController.swift
//  On The Map
//
//  Created by Dylan Edwards on 5/20/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, AlertPresentable, ActivityIndicatorPresentable, SegueHandlerType, SafariViewControllerPresentable {
    
    /** 
     Admittedly this is silly for a single segue, but I want to standardize the
     segue presentation process for all apps using SegueHandlerType protocol
     */
    enum SegueIdentifier: String {
        case LoginComplete
    }
    
    private var loginView: LoginView!

    internal var activityIndicatorViewController: ActivityIndicatorViewController?
    private var overlayTransitioningDelegate: OverlayTransitioningDelegate?
    
    private var mainTabBarController: TabBarController?
    
    private var successfulLogoutCompletion: (() -> Void)!
    
    //MARK: - View Lifecycle
    
    override func viewWillAppear(animated: Bool) {
        /// free up memory if just logged out
        if mainTabBarController != nil {
            mainTabBarController = nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let presentActivityIndicator = { (completion: (() -> Void)?) in
            self.overlayTransitioningDelegate = OverlayTransitioningDelegate()
            self.presentActivityIndicator(
                self.getActivityIndicatorViewController(),
                transitioningDelegate: self.overlayTransitioningDelegate!,
                completion: completion)
        }
        
        let presentErrorAlert = getAlertPresentation()

        let loginSuccessClosure = {
            self.dismissActivityIndicator(completion: {
                self.overlayTransitioningDelegate = nil
                self.performSegueWithIdentifier(.LoginComplete, sender: self)
            })
        }
        
        let openUdacitySignUp = {
            self.openLinkInSafari(withURLString: Constants.Network.udacitySignUpURL)
        }
        
        loginView = view as! LoginView
        
        loginView.configure(
            withActivityIndicatorPresentation: presentActivityIndicator,
            successClosure: loginSuccessClosure,
            alertPresentationClosure: presentErrorAlert,
            openUdacitySignUp: openUdacitySignUp)
    }
    
    
    //MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        /// Overkill for this situation, but would be useful for multiple seques
        switch segueIdentifierForSegue(segue) {
        case .LoginComplete:
            mainTabBarController = segue.destinationViewController as? TabBarController
        }
    }
}
