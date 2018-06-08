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
    
    fileprivate var presentErrorAlert: AlertPresentation!
    fileprivate var openSignUpPage: (() -> Void)!
    
    fileprivate var emailString     = ""
    fileprivate var passwordString  = ""
    
    fileprivate var emailTextFieldFontColor = Theme.textError
    fileprivate var textFieldAttributes = [
        NSFontAttributeName: UIFont(name: Constants.FontName.avenirLight, size: 17)!,
        NSForegroundColorAttributeName: UIColor.redOrange()
    ]
    
    fileprivate lazy var loginValidator = LoginValidator()
    
    fileprivate let gradientLayer = CAGradientLayer()
    
    fileprivate var starAnimationHolderView: StarAnimationHolderView!
    fileprivate var titleAnimationHolderView = TitleAnimationHolderView()
    
    fileprivate let starAnimationDuration: CFTimeInterval = 1.5
    
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
    
    @IBAction func loginAction(_ sender: AnyObject) {
        let emailLogin = (email: emailString, password: passwordString)
        loginValidator.login(withEmailAndPassword: emailLogin)
        
        initiateLogin(withEmailAndPassword: emailLogin)
    }
    
    @IBAction func signUpAction(_ sender: AnyObject) {
        openSignUpPage()
    }
    
    //MARK: - Configuration
    
    internal func configure(
        withActivityIndicatorPresentation presentAI: (_ completion: (() -> Void)?) -> Void,
        successClosure success:() -> Void,
        alertPresentationClosure alertPresentation: @escaping AlertPresentation,
        openUdacitySignUp signUpClosure: @escaping () -> Void) {
        
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
        let popTime = DispatchTime.now() + Double(Int64(delayInSeconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: popTime) {
            self.beginIntroAnimation()
        }
    }
    
    fileprivate func configureBackground() {
        backgroundColor = Theme.loginScreenBGColor

        gradientLayer.frame = bounds
        
        let color1 = UIColor.clear.cgColor
        let color2 = Theme.loginScreenBGGradient.cgColor
        
        gradientLayer.colors = [color1, color2]
        gradientLayer.locations = [0.6, 1.0]
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    fileprivate func configureLabels() {
        
        /// Login
        
        let loginLabelAttributes: [String : AnyObject] = [
            NSForegroundColorAttributeName: Theme.textLight,
            NSFontAttributeName: UIFont(name: Constants.FontName.avenirHeavy, size: 20)!]
        
        loginToUdacityLabel.attributedText = NSAttributedString(string: LocalizedStrings.Labels.loginToUdacity, attributes: loginLabelAttributes)
        
        loginToUdacityLabel.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
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
        
        attributedString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: LocalizedStrings.Labels.dontHaveAccount.characters.count + 1, length: LocalizedStrings.Labels.signUp.characters.count))
        
        noAccountLabel.attributedText   = attributedString
        noAccountLabel.transform        = CGAffineTransform(scaleX: 0.1, y: 0.1)
        noAccountLabel.alpha            = 0
    }
    
    fileprivate func configureTextField(_ textField: UITextField, placeholderText placeholder: String, secureTextEntry secure: Bool) {
        
        textField.backgroundColor   = Theme.textFieldBackground
        textField.delegate          = self
        textField.placeholder       = placeholder
        textField.isSecureTextEntry   = secure
        textField.alpha             = 0
        textField.transform         = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        textField.addTarget(self, action: #selector(validateTextFields), for: .editingChanged)
    }
    
    fileprivate func configureEmailFieldAttributes() {
        textFieldAttributes[NSForegroundColorAttributeName] = emailTextFieldFontColor
        
        emailField.defaultTextAttributes = textFieldAttributes
    }
    
    fileprivate func configureButtons() {
        loginButton.titleLabel?.text    = LocalizedStrings.ButtonTitles.login
        loginButton.isEnabled             = true//false
        loginButton.backgroundColor     = Theme.buttonBackground
        loginButton.tintColor           = Theme.buttonTint
        loginButton.layer.cornerRadius  = 6
        loginButton.alpha               = 0
        loginButton.transform           = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        signUpButton.setTitle(nil, for: UIControlState())
        signUpButton.alpha              = 0
        signUpButton.transform          = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        self.addSubview(facebookLoginButton)
        facebookLoginButton.center.x = self.center.x
        facebookLoginButton.center.y = self.frame.height - 50
        facebookLoginButton.readPermissions = ["email"]
        facebookLoginButton.delegate = self
        facebookLoginButton.alpha = 0
        facebookLoginButton.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
    }
    
    //MARK: - Facebook check
    
    fileprivate func checkForLoggedIntoFacebook() {
        guard let token = FBSDKAccessToken.current() as FBSDKAccessToken! else {
            return
        }
        initiateLogin(withFacebookToken: token)
    }
    
    
    fileprivate func initiateLogin(withEmailAndPassword loginTuple:(email: String, password: String)? = nil, withFacebookToken token: FBSDKAccessToken? = nil) {
        
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
        
        loginButton.isEnabled = emailString.isEmail && passwordString != "" ? true : false
        
        configureEmailFieldAttributes()
    }
    
    //MARK: - Animations
    
    fileprivate func beginIntroAnimation() {
        /**
         A delay is needed because for some reason the animation breaks if it's
         kicked off immediately from configure(). The scale transform works, but the
         constraint animation doesn't.
         */
        let delayInSeconds = 0.5
        let popTime = DispatchTime.now() + Double(Int64(delayInSeconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: popTime) {
            self.animateStarAlongPath()
        }
    }
    
    fileprivate func animateStarAlongPath() {
        self.starAnimationHolderView = StarAnimationHolderView(withDuration: starAnimationDuration)
        insertSubview(starAnimationHolderView, at: 0)
        
        let delayInSeconds = starAnimationDuration
        let popTime = DispatchTime.now() + Double(Int64(delayInSeconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: popTime) {
            self.addTitleHolderView()
        }
    }
    
    fileprivate func addTitleHolderView() {
        titleAnimationHolderView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        
        insertSubview(titleAnimationHolderView, at: 0)
        
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
    
    fileprivate func animateView(_ view: UIView, delay: Double) {
        UIView.animate(withDuration: 0.5, delay: delay, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
            
            view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            view.alpha = 1.0
            self.layoutIfNeeded()
            }, completion: nil)
    }
}

//MARK: - UITextFieldDelegate
extension LoginView: UITextFieldDelegate {
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - FBSDKLoginButtonDelegate
extension LoginView: FBSDKLoginButtonDelegate {
    
    internal func loginButton(_ loginButton: FBSDKLoginButton, didCompleteWith result: FBSDKLoginManagerLoginResult, error: Error?) {
        
        if error != nil {
            presentErrorAlert((title: LocalizedStrings.AlertTitles.loginError, message: error!.localizedDescription))
            return
        }
        initiateLogin(withFacebookToken: result.token)
    }
    
    internal func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        magic("User Logged Out")
    }
}
