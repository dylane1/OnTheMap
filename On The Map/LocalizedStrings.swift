//
//  LocalizedStrings.swift
//  On The Map
//
//  Created by Dylan Edwards on 5/18/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import Foundation

struct LocalizedStrings {
    struct ViewControllerTitles {
        static let onTheMap = NSLocalizedString("ViewControllerTitles.onTheMap", value: "On The Map", comment: "")
        
    }
    
    struct BarButtonTitles {
        static let logout = NSLocalizedString("BarButtonTitles.logout", value: "Logout", comment: "")
    }
    
    struct ButtonTitles {
        static let login    = NSLocalizedString("ButtonTitles.login", value: "Login", comment: "")
        static let submit   = NSLocalizedString("ButtonTitles.submit", value: "Submit", comment: "")
        static let signInWithFacebook = NSLocalizedString("ButtonTitles.signInWithFacebook", value: "Sign in with Facebook", comment: "")
    }
    
    struct TextFieldPlaceHolders {
        static let email            = NSLocalizedString("TextFieldPlaceHolders.email", value: "Email", comment: "")
        static let password         = NSLocalizedString("TextFieldPlaceHolders.password", value: "Password", comment: "")
        static let enterLocation    = NSLocalizedString("TextFieldPlaceHolders.enterLocation", value: "Enter Location", comment: "")
        static let enterURL         = NSLocalizedString("TextFieldPlaceHolders.enterURL", value: "Enter URL", comment: "")
    }
    
    struct Labels {
        static let loginToUdacity   = NSLocalizedString("Labels.loginToUdacity", value: "Login To Udacity", comment: "")
        static let whereAreYou      = NSLocalizedString("Labels.whereAreYou", value: "Where Are You\nStudying Today", comment: "")
    }
    
    struct AlertTitles {
        static let error                = NSLocalizedString("AlertTitles.error", value: "Error", comment: "")
        static let locationSearchError  = NSLocalizedString("AlertTitles.locationSearchError", value: "Location Search Error", comment: "")
        static let locationUpdateError  = NSLocalizedString("AlertTitles.locationUpdateError", value: "Location Update Error", comment: "")
        static let loginError           = NSLocalizedString("AlertTitles.loginError", value: "Login Error", comment: "")
    }
    
    struct AlertMessages {
        static let pleaseTrySearchAgain = NSLocalizedString("AlertMessages.pleaseTrySearchAgain", value: "Unable to find your location, please enter your location again.", comment: "")
        static let pleaseTryUpdateAgain = NSLocalizedString("AlertMessages.pleaseTryUpdateAgain", value: "Unable to update your location, please try again.", comment: "")
//        static let loginErrorReason = NSLocalizedString("AlertMessages.loginErrorReason", value: "Unable to login for the following reason:", comment: "")
        static let unknownLoginError = NSLocalizedString("AlertMessages.unknownLoginError", value: "Unknown login error, please try again.", comment: "")
        static let invalidCredentials = NSLocalizedString("AlertMessages.invalidCredentials", value: "Account not found or invalid credentials.", comment: "")
        static let pleaseEnterUsername = NSLocalizedString("AlertMessages.pleaseEnterUsername", value: "Please enter a valid username.", comment: "")
        static let pleaseEnterPassword = NSLocalizedString("AlertMessages.pleaseEnterPassword", value: "Please enter a password.", comment: "")
    }
    
    struct AlertButtonTitles {
        static let ok = NSLocalizedString("AlertButtonTitles.ok", value: "OK", comment: "")
//        static let cancel = NSLocalizedString("AlertButtonTitles.cancel", value: "Cancel",    comment: "")
    }
}
