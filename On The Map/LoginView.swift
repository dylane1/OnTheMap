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
    
    private var loginInitiatedClosure: (() -> Void)!
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
//        let emailLogin = (email: "", password: "1234")
//        let emailLogin = (email: Constants.Testing.myValidUsername, password: "1234")
//        let emailLogin = (email: Constants.Testing.myValidUsername, password: "")
        
        initiateLogin(withEmailAndPassword: emailLogin)
    }
    
    //MARK: - Configuration
    
    internal func configure(withLoginInitiatedClosure loginInit: () -> Void, loginSuccessClosure loginSuccess: () -> Void, alertPresentationClosure alertPresent: AlertPresentationClosureWithParameters) {
        backgroundColor = Constants.ColorScheme.orange
        
        loginInitiatedClosure                   = loginInit
        loginSuccessClosure                     = loginSuccess
        alertPresentationClosureWithParameters  = alertPresent
        
        loginValidator.configure(withLoginSuccessClosure: loginSuccess, alertPresentationClosure: alertPresent)
        
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
        
        let loginView = FBSDKLoginButton()
        self.addSubview(loginView)
        loginView.center.x = self.center.x
        loginView.center.y = self.frame.height - 50
        loginView.readPermissions = ["email"]
        loginView.delegate = self
    }
    
    //MARK: - Facebook check
    private func checkForLoggedIntoFacebook() {
        guard let token = FBSDKAccessToken.currentAccessToken() as FBSDKAccessToken! else {
            return
        }
        initiateLogin(withFacebookToken: token)
    }
    
    
    private func initiateLogin(withEmailAndPassword loginTuple:(email: String, password: String)? = nil, withFacebookToken token: FBSDKAccessToken? = nil) {
        
        /// Show activity indicator
        loginInitiatedClosure()
        
        if loginTuple != nil {
            loginValidator.login(withEmailAndPassword: loginTuple)
        } else if token != nil {
            loginValidator.login(withFacebookToken: token)
        } else {
            fatalError("That's not going to work...")
        }
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

        if error != nil {
            alertPresentationClosureWithParameters((title: LocalizedStrings.AlertTitles.loginError, message: error!.localizedDescription))
            return
        }
        initiateLogin(withFacebookToken: result.token)
    }
    
    internal func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        magic("User Logged Out")
    }
}






































