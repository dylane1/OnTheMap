//
//  LoginViewController.swift
//  On The Map
//
//  Created by Dylan Edwards on 5/20/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, AlertPresentable, ActivityIndicatorPresentable, SegueHandlerType {
    
    enum SegueIdentifier: String {
        case LoginComplete
    }
    
    private var loginView: LoginView!

    private var activityIndicatorVC: PrimaryActivityIndicatorViewController?
    private var mainTabBarController: TabBarController?
    
    private var successfulLogoutCompletion: (() -> Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//
        let loginInitiatedClosure = { [unowned self] in
            self.activityIndicatorVC = self.getActivityIndicatorViewController()
            self.presentActivityIndicator(self.activityIndicatorVC!, completion: nil)
        }
        
        let loginSuccessClosure = { [unowned self] in
            let dismissalCompletion = { [unowned self] in
                self.performSegueWithIdentifier(.LoginComplete, sender: self)
            }
            self.dismissActivityIndicator(self.activityIndicatorVC!, completion: dismissalCompletion)
        }
        
        successfulLogoutCompletion = { [unowned self] in
            /**
             Ok, I probably don't need this, but I want to make sure everything
             is getting dealloc'd. Unfortunately this is not the case currently.
             Guessing I've got some retain cycles somewhere that I need to track
             down.
             */
            self.mainTabBarController = nil
        }
        
        loginView = view as! LoginView
        
        loginView.configure(withLoginInitiatedClosure: loginInitiatedClosure, loginSuccessClosure: loginSuccessClosure, alertPresentationClosure: getAlertPresentationClosure())
    }
    
    //MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        mainTabBarController = segue.destinationViewController as? TabBarController
        mainTabBarController!.successfulLogoutCompletion = successfulLogoutCompletion
    }
}
