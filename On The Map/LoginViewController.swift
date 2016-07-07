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
//        case ShowLoginActivityIndicator
        case LoginComplete
    }
    
    private var loginView: LoginView!

    private var activityIndicatorVC: PrimaryActivityIndicatorViewController?
    private var mainTabBarController: TabBarController?
    
    private var successfulLogoutCompletion: (() -> Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginInitiatedClosure = { [unowned self] in
            let dismissalCompletion = { [unowned self] in
                self.performSegueWithIdentifier(.LoginComplete, sender: self)
            }
            self.activityIndicatorVC = self.getActivityIndicatorViewController(withDismissalCompletion: dismissalCompletion)
            self.presentViewController(self.activityIndicatorVC!, animated: false, completion: nil)
        }
        
        let loginSuccessClosure = { [unowned self] in
            self.activityIndicatorVC!.vcShouldBeDismissed!()
//            self.performSegueWithIdentifier(.LoginComplete, sender: self)
        }
        
        successfulLogoutCompletion = { [unowned self] in
            magic("setting tab-bar to nil")
            self.mainTabBarController = nil
        }
        
        loginView = view as! LoginView
        
        loginView.configure(withLoginInitiatedClosure: loginInitiatedClosure, loginSuccessClosure: loginSuccessClosure, alertPresentationClosure: getAlertPresentationClosure())
    }
    
    //MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segueIdentifierForSegue(segue) {
//        case .ShowLoginActivityIndicator:
//            magic("activity indicator")
        case .LoginComplete:
            mainTabBarController = segue.destinationViewController as? TabBarController
            mainTabBarController!.successfulLogoutCompletion = successfulLogoutCompletion
        }
    }
}
