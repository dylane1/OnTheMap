//
//  LoginViewController.swift
//  On The Map
//
//  Created by Dylan Edwards on 5/20/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    private var loginView: LoginView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginSuccess = { [weak self] in
            magic("Success!")
            
            
            self!.performSegueWithIdentifier(Constants.SegueID.loginComplete, sender: self)
        }
        
        loginView = view as! LoginView
        
        loginView.configure(withSuccessClosure: loginSuccess)
        
        //appModel = AppModel()
        
        //TODO: For testing nav, set to true
//        appModel.isLoggedInViaFacebook = true
    }
}
