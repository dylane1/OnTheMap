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
    
    private var loginSuccess: LoginSuccess!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginSuccess = { [weak self] in
            magic("Success!")
            self!.performSegueWithIdentifier(Constants.SegueID.loginComplete, sender: self)
        }
        
        loginView = view as! LoginView
        
        loginView.configure(withSuccessClosure: loginSuccess)
    }


    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

    
    //MARK: - 
    
}
