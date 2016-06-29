//
//  LoginView.swift
//  On The Map
//
//  Created by Dylan Edwards on 5/20/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

class LoginView: UIView {
    private var loginSuccessClosure: (() -> Void)!
    private var alertPresentationClosure: AlertPresentationClosure!
    
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
    @IBOutlet weak var signInWithFacebookButton: UIButton!
    
    
    //MARK: - Actions
    
    @IBAction func loginAction(sender: AnyObject) {
        loginValidator.configure(withLoginSuccessClosure: loginSuccessClosure, alertPresentationClosure: alertPresentationClosure)
//        loginValidator.verifyLogin(withEmail: Constants.Testing.myValidUsername, password: Constants.Testing.myValidPassword)
        loginValidator.verifyLogin(withEmail: Constants.Testing.myValidUsername, password: "")
//        loginValidator.verifyLogin(withEmail: emailString, password: passwordString)
    }
    
    //MARK: - Configuration
    
    internal func configure(withLoginSuccessClosure loginClosure: () -> Void, alertPresentationClosure alertClosure: AlertPresentationClosure) {
        backgroundColor = Constants.ColorScheme.orange
        
        loginSuccessClosure         = loginClosure
        alertPresentationClosure    = alertClosure
        
        configureLabels()
        configureTextFields()
        configureButtons()
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
        loginButton.enabled             = true //false
        
        signInWithFacebookButton.titleLabel?.text   = LocalizedStrings.ButtonTitles.signInWithFacebook
        signInWithFacebookButton.enabled            = false
    }
    
    
    /**
     * 1. Check for valid email & set color of text accordingly
     * 2. Check for both valid email & a non-empty password string & set login button enabled/disabled
     */
    internal func validateTextFields() {
        emailString     = emailField.text as String! ?? ""
        passwordString  = passwordField.text as String! ?? ""
        
        emailTextFieldFontColor = emailString.isEmail ? Constants.ColorScheme.black : Constants.ColorScheme.red
        
//        loginButton.enabled = emailString.isEmail && passwordString != "" ? true : false
        
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






































