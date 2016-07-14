//
//  LoginViewController.swift
//  On The Map
//
//  Created by Dylan Edwards on 5/20/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, AlertPresentable, ActivityIndicatorPresentable, SegueHandlerType {
    
    /** 
     Admittedly this is silly for a single segue, but I want to standardize the
     segue presentation process for all apps using SegueHandlerType protocol
     */
    enum SegueIdentifier: String {
        case LoginComplete
    }
    
    private var loginView: LoginView!

    internal var activityIndicatorViewController: ActivityIndicatorViewController?
    
    private var mainTabBarController: TabBarController?
    
    private var successfulLogoutCompletion: (() -> Void)!
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let presentActivityIndicator = { [unowned self] (completion: (() -> Void)?) in
            self.presentActivityIndicator(self.getActivityIndicatorViewController(), completion: completion)
        }
        
        let presentErrorAlert = getAlertPresentation()

        let loginSuccessClosure = { [unowned self] in
            self.dismissActivityIndicator(completion: {
                self.performSegueWithIdentifier(.LoginComplete, sender: self)
            })
        }
        
//        successfulLogoutCompletion = { [unowned self] in
//            /**
//             Ok, I probably don't need this, but I want to make sure everything
//             is getting dealloc'd. Unfortunately this is not the case currently.
//             Guessing I've got some retain cycles somewhere that I need to track
//             down.
//             */
//            self.mainTabBarController = nil
//        }
        
        loginView = view as! LoginView
        
        loginView.configure(
            withActivityIndicatorPresentation: presentActivityIndicator,
            successClosure: loginSuccessClosure,
            alertPresentationClosure: presentErrorAlert)
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
