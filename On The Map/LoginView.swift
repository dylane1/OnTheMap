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
    private var openSignUpPage: (() -> Void)!
    
    private var emailString     = ""
    private var passwordString  = ""
    
    private var emailTextFieldFontColor = Theme03.textError
    private var textFieldAttributes = [
        NSFontAttributeName: UIFont.systemFontOfSize(17, weight: UIFontWeightLight),
        NSForegroundColorAttributeName: UIColor.redOrange()
    ]
    
    private lazy var loginValidator = LoginValidator()
    
    private let gradientLayer = CAGradientLayer()
    
//    private var spiralAnimationPathView = SpiralAnimationPathLayer
    private var starAnimationHolderView = StarAnimationHolderView()
    private var titleAnimationHolderView = TitleAnimationHolderView()
    
    //MARK: - IBOutlets
    
//    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var loginToUdacityLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var noAccountLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginLabelTopConstraint: NSLayoutConstraint!
    
//    private var loginLabelConstraintConstantDestination: CGFloat!// = 100.0
    
    let facebookLoginButton = FBSDKLoginButton()
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
        configureTextFields()
        configureButtons()
        
        checkForLoggedIntoFacebook()
        
        /// Animation time!
        
        /// Adding a delay prevent animation glitch
        let delayInSeconds = 0.5
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
        
        dispatch_after(popTime, dispatch_get_main_queue()) {
            self.beginIntroAnimation()
//            self.addTitleHolderView()
        }
//        prepareForAnimation()
    }
    
    private func configureBackground() {
        backgroundColor = Theme03.loginScreenBGColor

        gradientLayer.frame = bounds
        
        let color1 = UIColor.clearColor().CGColor
        let color2 = Theme03.loginScreenBGGradient.CGColor
        
        gradientLayer.colors = [color1, color2]
        gradientLayer.locations = [0.6, 1.0]
        
        layer.insertSublayer(gradientLayer, atIndex: 0)
    }
    
    private func configureLabels() {
        
        /// Login
        
        let loginLabelAttributes: [String : AnyObject] = [
            NSForegroundColorAttributeName: Theme03.textLight,
            NSFontAttributeName: UIFont(name: Constants.FontName.avenir, size: 20)!]
        
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
        
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: Constants.FontName.avenir, size: 14)!, range: NSRange(location: 0, length: labelString.characters.count))
        
        attributedString.addAttribute(NSForegroundColorAttributeName, value: Theme03.textLight, range: NSRange(location: 0, length: labelString.characters.count))
        
        attributedString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: NSRange(location: LocalizedStrings.Labels.dontHaveAccount.characters.count + 1, length: LocalizedStrings.Labels.signUp.characters.count))
        
        noAccountLabel.attributedText   = attributedString
        noAccountLabel.transform        = CGAffineTransformMakeScale(0.1, 0.1)
        noAccountLabel.alpha            = 0
    }
    
    private func configureTextFields() {
        
        emailField.backgroundColor  = Theme03.textFieldBackground
        emailField.delegate         = self
        emailField.placeholder      = LocalizedStrings.TextFieldPlaceHolders.email
        emailField.addTarget(self, action: #selector(validateTextFields), forControlEvents: .EditingChanged)
        emailField.alpha = 0
        emailField.transform = CGAffineTransformMakeScale(0.1, 0.1)
        
        passwordField.backgroundColor   = Theme03.textFieldBackground
        passwordField.delegate          = self
        passwordField.secureTextEntry   = true
        passwordField.placeholder       = LocalizedStrings.TextFieldPlaceHolders.password
        passwordField.addTarget(self, action: #selector(validateTextFields), forControlEvents: .EditingChanged)
        passwordField.alpha = 0
        passwordField.transform = CGAffineTransformMakeScale(0.1, 0.1)
        
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
        
        emailTextFieldFontColor = emailString.isEmail ? Theme03.textFieldText : Theme03.textError
        
        loginButton.enabled = emailString.isEmail && passwordString != "" ? true : false
        
        configureTextFieldAttributes()
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
            self.addTitleHolderView()
        }
    }
    
    private func animateStarAlongPath() {
        
    }
    
    private func addTitleHolderView() {
        titleHolderView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        
        insertSubview(titleHolderView, atIndex: 0)
        
        titleHolderView.revealTitle(withClosure: {
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






































