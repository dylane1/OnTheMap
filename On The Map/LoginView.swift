//
//  LoginView.swift
//  On The Map
//
//  Created by Dylan Edwards on 5/20/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit
import FBSDKLoginKit


class LoginView: UIView {
    
    private var presentErrorAlert: AlertPresentation!
    private var openSignUpPage: (() -> Void)!
    
    private var emailString     = ""
    private var passwordString  = ""
    
    private var emailTextFieldFontColor = Theme.textError
    private var textFieldAttributes = [
        NSFontAttributeName: UIFont(name: Constants.FontName.avenirLight, size: 17)!,
        NSForegroundColorAttributeName: UIColor.redOrange()
    ]
    
    private lazy var loginValidator = LoginValidator()
    
    private let gradientLayer = CAGradientLayer()
    
    private var starAnimationHolderView: StarAnimationHolderView!
    private var titleAnimationHolderView = TitleAnimationHolderView()
    
    private let starAnimationDuration: CFTimeInterval = 1.5
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var loginToUdacityLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var noAccountLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginLabelTopConstraint: NSLayoutConstraint!
    
    let facebookLoginButton = FBSDKLoginButton()
    
    //MARK: - Actions
    
    @IBAction func loginAction(sender: AnyObject) {
        let emailLogin = (email: emailString, password: passwordString)
        loginValidator.login(withEmailAndPassword: emailLogin)
        
        initiateLogin(withEmailAndPassword: emailLogin)
    }
    
    @IBAction func signUpAction(sender: AnyObject) {
        openSignUpPage()
    }
    
    //MARK: - Configuration
    
    internal func configure(
        withActivityIndicatorPresentation presentAI: (completion: (() -> Void)?) -> Void,
        successClosure success:() -> Void,
        alertPresentationClosure alertPresentation: AlertPresentation,
        openUdacitySignUp signUpClosure: () -> Void) {
        
        presentErrorAlert   = alertPresentation
        openSignUpPage      = signUpClosure
        
        loginValidator.configure(
            withActivityIndicatorPresentation: presentAI,
            loginSuccessClosure: success,
            alertPresentationClosure: alertPresentation)
        
        configureBackground()
        configureLabels()
        configureTextField(emailField, placeholderText: LocalizedStrings.TextFieldPlaceHolders.email, secureTextEntry: false)
        configureTextField(passwordField, placeholderText: LocalizedStrings.TextFieldPlaceHolders.password, secureTextEntry: true)
        configureEmailFieldAttributes()
        configureButtons()
        
        checkForLoggedIntoFacebook()
        
        /// Animation time!
        
        /// Adding a delay prevent animation glitch
        let delayInSeconds = 0.5
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
        
        dispatch_after(popTime, dispatch_get_main_queue()) {
            self.beginIntroAnimation()
        }
    }
    
    private func configureBackground() {
        backgroundColor = Theme.loginScreenBGColor

        gradientLayer.frame = bounds
        
        let color1 = UIColor.clearColor().CGColor
        let color2 = Theme.loginScreenBGGradient.CGColor
        
        gradientLayer.colors = [color1, color2]
        gradientLayer.locations = [0.6, 1.0]
        
        layer.insertSublayer(gradientLayer, atIndex: 0)
    }
    
    private func configureLabels() {
        
        /// Login
        
        let loginLabelAttributes: [String : AnyObject] = [
            NSForegroundColorAttributeName: Theme.textLight,
            NSFontAttributeName: UIFont(name: Constants.FontName.avenirHeavy, size: 20)!]
        
        loginToUdacityLabel.attributedText = NSAttributedString(string: LocalizedStrings.Labels.loginToUdacity, attributes: loginLabelAttributes)
        
        loginToUdacityLabel.transform = CGAffineTransformMakeScale(0.1, 0.1)
        loginToUdacityLabel.alpha = 0
        
        /// Slightly different layout for each device
        switch Constants.screenHeight {
        case Constants.DeviceScreenHeight.iPhone4s:
            loginLabelTopConstraint.constant = 100
        case Constants.DeviceScreenHeight.iPhone5:
            loginLabelTopConstraint.constant = 120
        case Constants.DeviceScreenHeight.iPhone6:
            loginLabelTopConstraint.constant = 140
        default:
            /// iPhone6Plus
            loginLabelTopConstraint.constant = 160
        }
        
        /// Don't have account
        
        let labelString = LocalizedStrings.Labels.dontHaveAccount + " " + LocalizedStrings.Labels.signUp
        
        let attributedString = NSMutableAttributedString(string: labelString)
        
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: Constants.FontName.avenirMedium, size: 15)!, range: NSRange(location: 0, length: labelString.characters.count))
        
        attributedString.addAttribute(NSForegroundColorAttributeName, value: Theme.textLight, range: NSRange(location: 0, length: labelString.characters.count))
        
        attributedString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: NSRange(location: LocalizedStrings.Labels.dontHaveAccount.characters.count + 1, length: LocalizedStrings.Labels.signUp.characters.count))
        
        noAccountLabel.attributedText   = attributedString
        noAccountLabel.transform        = CGAffineTransformMakeScale(0.1, 0.1)
        noAccountLabel.alpha            = 0
    }
    
    private func configureTextField(textField: UITextField, placeholderText placeholder: String, secureTextEntry secure: Bool) {
        
        textField.backgroundColor   = Theme.textFieldBackground
        textField.delegate          = self
        textField.placeholder       = placeholder
        textField.secureTextEntry   = secure
        textField.alpha             = 0
        textField.transform         = CGAffineTransformMakeScale(0.1, 0.1)
        
        textField.addTarget(self, action: #selector(validateTextFields), forControlEvents: .EditingChanged)
    }
    
    private func configureEmailFieldAttributes() {
        textFieldAttributes[NSForegroundColorAttributeName] = emailTextFieldFontColor
        
        emailField.defaultTextAttributes = textFieldAttributes
    }
    
    private func configureButtons() {
        loginButton.titleLabel?.text    = LocalizedStrings.ButtonTitles.login
        loginButton.enabled             = true//false
        loginButton.backgroundColor     = Theme.buttonBackground
        loginButton.tintColor           = Theme.buttonTint
        loginButton.layer.cornerRadius  = 6
        loginButton.alpha               = 0
        loginButton.transform           = CGAffineTransformMakeScale(0.1, 0.1)
        
        signUpButton.setTitle(nil, forState: .Normal)
        signUpButton.alpha              = 0
        signUpButton.transform          = CGAffineTransformMakeScale(0.1, 0.1)
        
        self.addSubview(facebookLoginButton)
        facebookLoginButton.center.x = self.center.x
        facebookLoginButton.center.y = self.frame.height - 50
        facebookLoginButton.readPermissions = ["email"]
        facebookLoginButton.delegate = self
        facebookLoginButton.alpha = 0
        facebookLoginButton.transform = CGAffineTransformMakeScale(0.1, 0.1)
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
        
        emailTextFieldFontColor = emailString.isEmail ? Theme.textFieldText : Theme.textError
        
        loginButton.enabled = emailString.isEmail && passwordString != "" ? true : false
        
        configureEmailFieldAttributes()
    }
    
    //MARK: - Animations
    
    private func beginIntroAnimation() {
        /**
         A delay is needed because for some reason the animation breaks if it's
         kicked off immediately from configure(). The scale transform works, but the
         constraint animation doesn't.
         */
        let delayInSeconds = 0.5
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
        
        dispatch_after(popTime, dispatch_get_main_queue()) {
            self.animateStarAlongPath()
        }
    }
    
    private func animateStarAlongPath() {
        self.starAnimationHolderView = StarAnimationHolderView(withDuration: starAnimationDuration)
        insertSubview(starAnimationHolderView, atIndex: 0)
        
        let delayInSeconds = starAnimationDuration
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
        
        dispatch_after(popTime, dispatch_get_main_queue()) {
            self.addTitleHolderView()
        }
    }
    
    private func addTitleHolderView() {
        titleAnimationHolderView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        
        insertSubview(titleAnimationHolderView, atIndex: 0)
        
        titleAnimationHolderView.revealTitle(withClosure: {
            self.kickOffOtherAnimations()
        })
    }
    
    internal func kickOffOtherAnimations() {
        animateView(loginToUdacityLabel, delay: 0.0)
        animateView(emailField, delay: 0.1)
        animateView(passwordField, delay: 0.2)
        animateView(loginButton, delay: 0.3)
        animateView(noAccountLabel, delay: 0.4)
        animateView(signUpButton, delay: 0.4)
        animateView(facebookLoginButton, delay: 0.5)
    }
    
    private func animateView(view: UIView, delay: Double) {
        UIView.animateWithDuration(0.5, delay: delay, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: .CurveEaseOut, animations: {
            
            view.transform = CGAffineTransformMakeScale(1.0, 1.0)
            view.alpha = 1.0
            self.layoutIfNeeded()
            }, completion: nil)
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
            presentErrorAlert(alertParameters: (title: LocalizedStrings.AlertTitles.loginError, message: error!.localizedDescription))
            return
        }
        initiateLogin(withFacebookToken: result.token)
    }
    
    internal func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        magic("User Logged Out")
    }
}
