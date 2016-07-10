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
    
    private var presentErrorAlert: AlertPresentation!
    
    private var emailString     = ""
    private var passwordString  = ""
    
    private var emailTextFieldFontColor = Constants.ColorScheme.red
    private var textFieldAttributes = [
        NSFontAttributeName: UIFont.systemFontOfSize(17, weight: UIFontWeightLight),
        NSForegroundColorAttributeName: UIColor.redOrange()
    ]
    
    private lazy var loginValidator = LoginValidator()
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
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
    
    internal func configure(
        withActivityIndicatorPresentation presentAI: (completion: (() -> Void)?) -> Void,
        successClosure success:() -> Void,
        alertPresentationClosure alertPresentation: AlertPresentation) {
        
        backgroundColor = Theme03.loginScreenBGColor

        presentErrorAlert = alertPresentation
        
        loginValidator.configure(
            withActivityIndicatorPresentation: presentAI,
            loginSuccessClosure: success,
            alertPresentationClosure: alertPresentation)
        
        configureTitleView()
        configureLabels()
        configureTextFields()
        configureButtons()
        
        checkForLoggedIntoFacebook()
        
        titleViewAnimation()
    }
    
    private func configureTitleView() {
        titleView.backgroundColor = UIColor.clearColor()
        titleView.alpha        = 0
        titleView.transform    = CGAffineTransformMakeScale(0.5, 0.5)
    }
    
    private func configureLabels() {
        /// Title
        let titleShadow = NSShadow()
        titleShadow.shadowColor = Theme03.shadowDark
        titleShadow.shadowOffset = CGSize(width: -1.0, height: -1.0)
        titleShadow.shadowBlurRadius = 5
        
        let titleLabelAttributes: [String : AnyObject] = [
            NSShadowAttributeName: titleShadow,
            NSForegroundColorAttributeName: Theme03.textLight,
            NSFontAttributeName: UIFont(name: Constants.FontName.markerFelt, size: 50)!]
        
        titleLabel.adjustsFontSizeToFitWidth = true
        
        titleLabel.attributedText = NSAttributedString(string: LocalizedStrings.ViewControllerTitles.onTheMap, attributes: titleLabelAttributes)
        
        
        /// Login
        let loginLabelShadow = NSShadow()
        loginLabelShadow.shadowColor = Theme03.shadowDark
        loginLabelShadow.shadowOffset = CGSize(width: -1.0, height: -1.0)
        loginLabelShadow.shadowBlurRadius = 2
        
        let loginLabelAttributes: [String : AnyObject] = [
            NSShadowAttributeName: loginLabelShadow,
            NSForegroundColorAttributeName: Theme03.textLight,
            NSFontAttributeName: UIFont(name: Constants.FontName.avenir, size: 20)!]
        
        loginToUdacityLabel.attributedText = NSAttributedString(string: LocalizedStrings.Labels.loginToUdacity, attributes: loginLabelAttributes)
    }
    
    private func configureTextFields() {
        
        emailField.backgroundColor  = Theme03.textFieldBackground
        emailField.delegate         = self
        emailField.placeholder      = LocalizedStrings.TextFieldPlaceHolders.email
        emailField.addTarget(self, action: #selector(validateTextFields), forControlEvents: .EditingChanged)
        
        passwordField.backgroundColor   = Theme03.textFieldBackground
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
        loginButton.backgroundColor     = Theme03.buttonBackground
        loginButton.tintColor           = Theme03.buttonTint
        loginButton.layer.cornerRadius  = 6
        
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
        
        if loginTuple != nil {
            loginValidator.login(withEmailAndPassword: loginTuple)
        } else if token != nil {
            loginValidator.login(withFacebookToken: token)
        } else {
            magic("That's not going to work...")
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
        
        emailTextFieldFontColor = emailString.isEmail ? Theme03.textFieldText : Constants.ColorScheme.red
        
        loginButton.enabled = emailString.isEmail && passwordString != "" ? true : false
        
        configureTextFieldAttributes()
    }
    
    //MARK: - Animations
    
    private func titleViewAnimation() {
        UIView.animateWithDuration(0.7, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: .CurveEaseOut, animations: {
            self.titleView.transform = CGAffineTransformMakeScale(1.0, 1.0)
            self.titleView.alpha = 1.0
//            self.layoutIfNeeded()
            }, completion: nil)
    }
    
//    private func animateURLTextFieldIntoView() {
//        UIView.animateWithDuration(0.5, animations: {
//            self.urlTextFieldTopConstraint.constant += (self.urlTextField.frame.height + 4)
//            self.urlTextField.alpha = 1.0
//            self.layoutIfNeeded()
//            }, completion: nil)
//    }
//    
//    private func animateBottomButtonIntoView() {
//        UIView.animateWithDuration(1.7, delay: 0.5, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: .CurveEaseOut, animations: {
//            self.bottomButton.transform = CGAffineTransformMakeScale(1.0, 1.0)
//            self.bottomButton.alpha = 1.0
//            self.layoutIfNeeded()
//            }, completion: nil)
//    }
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
            presentErrorAlert(alertParameters: (title: LocalizedStrings.AlertTitles.loginError, message: error!.localizedDescription))
            return
        }
        initiateLogin(withFacebookToken: result.token)
    }
    
    internal func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        magic("User Logged Out")
    }
}






































