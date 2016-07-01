//
//  LoginViewController.swift
//  On The Map
//
//  Created by Dylan Edwards on 5/20/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, AlertPresentable {
    private var loginView: LoginView!

    private var mainTabBarController: TabBarController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginSuccessClosure = { [unowned self] in
            self.performSegueWithIdentifier(Constants.SegueID.loginComplete, sender: self)
        }
        
        loginView = view as! LoginView
        
        loginView.configure(withLoginSuccessClosure: loginSuccessClosure, alertPresentationClosure: getAlertPresentationClosure())
    }
    
    //MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.SegueID.loginComplete {
            mainTabBarController = segue.destinationViewController as? TabBarController
        }
    }
}
