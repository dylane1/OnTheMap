//
//  LoginView.swift
//  On The Map
//
//  Created by Dylan Edwards on 5/20/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit
//import FBSDKCoreKit
import FBSDKLoginKit


class LoginView: UIView {
    
    private var loginSuccessClosure: (() -> Void)!
    private var alertPresentationClosureWithParameters: AlertPresentationClosureWithParameters!
    
    private var emailString     = ""
    private var passwordString  = ""
    
    private var emailTextFieldFontColor = Constants.ColorScheme.red
    private var textFieldAttributes = [
        NSFontAttributeName: UIFont.systemFontOfSize(17, weight: UIFontWeightLight),
        NSForegroundColorAttributeName: Constants.ColorScheme.red
    ]
    
    private lazy var loginValidator = LoginValidator()
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var loginToUdacityLabel: UILabel!
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    //MARK: - Actions
    
    @IBAction func loginAction(sender: AnyObject) {
        /// Login (real data)
//        let emailLogin = (email: emailString, password: passwordString)
//        loginValidator.login(withEmailAndPassword: emailLogin)
        
        ///TESTING:
        let emailLogin = (email: Constants.Testing.myValidUsername, password: Constants.Testing.myValidPassword)
        loginValidator.login(withEmailAndPassword: emailLogin)
//        loginValidator.verifyLogin(withEmail: "", password: "")
//        loginValidator.login()
//        loginValidator.verifyLogin(withEmail: Constants.Testing.myValidUsername, password: "")
    }
    
    //MARK: - Configuration
    
    internal func configure(withLoginSuccessClosure loginClosure: () -> Void, alertPresentationClosure alertClosure: AlertPresentationClosureWithParameters) {
        backgroundColor = Constants.ColorScheme.orange
        
        loginSuccessClosure                     = loginClosure
        alertPresentationClosureWithParameters  = alertClosure
        
        loginValidator.configure(withLoginSuccessClosure: loginClosure, alertPresentationClosure: alertClosure)
        
        configureLabels()
        configureTextFields()
        configureButtons()

        checkForLoggedIntoFacebook()
    }
    
    private func configureLabels() {
        loginToUdacityLabel.text = LocalizedStrings.Labels.loginToUdacity
    }
    
    private func configureTextFields() {
        emailField.delegate     = self
        emailField.placeholder  = LocalizedStrings.TextFieldPlaceHolders.email
        emailField.addTarget(self, action: #selector(validateTextFields), forControlEvents: .EditingChanged)
        
        passwordField.delegate          = self
        passwordField.secureTextEntry   = true
        passwordField.placeholder       = LocalizedStrings.TextFieldPlaceHolders.password
        passwordField.addTarget(self, action: #selector(validateTextFields), forControlEvents: .EditingChanged)
        
        configureTextFieldAttributes()
    }
    
    private func configureTextFieldAttributes() {
        textFieldAttributes[NSForegroundColorAttributeName] = emailTextFieldFontColor
        
        emailField.defaultTextAttributes = textFieldAttributes
    }
    
    private func configureButtons() {
        loginButton.titleLabel?.text    = LocalizedStrings.ButtonTitles.login
        loginButton.enabled             = true//false
    }
    
    //MARK: - Facebook check
    private func checkForLoggedIntoFacebook() {
        guard let token = FBSDKAccessToken.currentAccessToken() as FBSDKAccessToken! else {
            magic("awwww, not logged in...")
            let loginView = FBSDKLoginButton()
            self.addSubview(loginView)
            loginView.center.x = self.center.x
            loginView.center.y = self.frame.height - 50
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
            return
        }
        loginValidator.login(withFacebookToken: token)
    }
    
    //MARK: -
    /**
     * 1. Check for valid email & set color of text accordingly
     * 2. Check for both valid email & a non-empty password string & set login button enabled/disabled
     */
    internal func validateTextFields() {
        emailString     = emailField.text as String! ?? ""
        passwordString  = passwordField.text as String! ?? ""
        
        emailTextFieldFontColor = emailString.isEmail ? Constants.ColorScheme.black : Constants.ColorScheme.red
        
        loginButton.enabled = emailString.isEmail && passwordString != "" ? true : false
        
        configureTextFieldAttributes()
    }
}

//MARK: - UITextFieldDelegate
extension LoginView: UITextFieldDelegate {
    
    internal func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - FBSDKLoginButtonDelegate
extension LoginView: FBSDKLoginButtonDelegate {
    
    internal func loginButton(loginButton: FBSDKLoginButton, didCompleteWithResult result: FBSDKLoginManagerLoginResult, error: NSError?) {
        
        magic("login button: \(loginButton); result: \(result); error: \(error)")
        
        if error != nil {
            alertPresentationClosureWithParameters((title: LocalizedStrings.AlertTitles.loginError, message: error!.localizedDescription))
            return
        }
        loginSuccessClosure()
    }
    
    internal func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        magic("User Logged Out")
    }
    
//    internal func returnUserData() {
//        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
//        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
//            
//            if ((error) != nil) {
//                // Process error
//                magic("Error: \(error)")
//            } else {
//                magic("fetched user: \(result)")
//                let userName : NSString = result.valueForKey("name") as! NSString
//                magic("User Name is: \(userName)")
//                let userEmail : NSString = result.valueForKey("email") as! NSString
//                magic("User Email is: \(userEmail)")
//            }
//        })
//    }
}






































