//
//  LoginView.swift
//  On The Map
//
//  Created by Dylan Edwards on 5/20/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

class LoginView: UIView {

    @IBOutlet weak var loginToUdacityLabel: UILabel!
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signInWithFacebookButton: UIButton!
    
    
    
    //MARK: - Configuration
    
    internal func configure() {
        backgroundColor = Constants.ColorScheme.orange
        configureStrings()
    }
    
    private func configureStrings() {
        loginToUdacityLabel.text = LocalizedStrings.Labels.loginToUdacity
        emailField.placeholder = LocalizedStrings.TextFieldPlaceHolders.email
        passwordField.placeholder = LocalizedStrings.TextFieldPlaceHolders.password
        loginButton.titleLabel?.text = LocalizedStrings.ButtonTitles.login
        signInWithFacebookButton.titleLabel?.text = LocalizedStrings.ButtonTitles.signInWithFacebook
    }
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
