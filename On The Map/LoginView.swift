//
//  LoginView.swift
//  On The Map
//
//  Created by Dylan Edwards on 5/20/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

class LoginView: UIView {
    private var udacitySuccessfulLogin: LoginSuccess!
    
    private lazy var loginValidator = LoginValidation()
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var loginToUdacityLabel: UILabel!
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signInWithFacebookButton: UIButton!
    
    
    //MARK: - Actions
    
    @IBAction func loginAction(sender: AnyObject) {
//        guard let email = emailField.text as String! where email != "", let pw = passwordField.text as String! where pw != "" else {
//            magic("empty field")
//            return
//        }
//        if !email.isEmail { magic("not a valid email") }
//        magic("Login attempt: email: \(email); pw: \(pw)")

        loginValidator.configure(withSuccessClosure: udacitySuccessfulLogin)
        loginValidator.verifyLogin(withEmail: Constants.Testing.myValidUsername, password: Constants.Testing.myValidPassword)
    }
    
    //MARK: - Configuration
    
    internal func configure(withSuccessClosure closure: LoginSuccess) {
        backgroundColor = Constants.ColorScheme.orange
        udacitySuccessfulLogin = closure
        
        configureStrings()
    }
    
    private func configureStrings() {
        loginToUdacityLabel.text = LocalizedStrings.Labels.loginToUdacity
        emailField.placeholder = LocalizedStrings.TextFieldPlaceHolders.email
        passwordField.placeholder = LocalizedStrings.TextFieldPlaceHolders.password
        loginButton.titleLabel?.text = LocalizedStrings.ButtonTitles.login
        signInWithFacebookButton.titleLabel?.text = LocalizedStrings.ButtonTitles.signInWithFacebook
    }
    
    private func configureTextFieldAttributes() {
        //TODO:
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

//MARK: - UITextFieldDelegate
extension LoginView: UITextFieldDelegate {
    //TODO:
    /** 
     * 1. Check for valid email & set color of text accordingly 
     * 2. Check for both valid email & a non-empty password string & set login button enabled/disabled
     */
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}
