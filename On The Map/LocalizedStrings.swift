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
        static let onTheMap = NSLocalizedString("titles.onTheMap", value: "On The Map", comment: "")
        static let whereAreYou  = NSLocalizedString("titles.whereAreYou", value: "Where Are You Today?", comment: "")
    }
    
    struct NavigationControllerButtons {
//        static let save     = NSLocalizedString("navBarButtons.save",   value: "Save",      comment: "")
//        static let clear    = NSLocalizedString("navBarButtons.clear",  value: "Clear",     comment: "")
//        static let cancel   = NSLocalizedString("navBarButtons.cancel", value: "Cancel",    comment: "")
//        static let back     = NSLocalizedString("navBarButtons.back",   value: "Back",      comment: "")
    }
    
    struct ButtonTitles {
        static let login                = NSLocalizedString("buttonTitles.login", value: "Login", comment: "")
        static let signInWithFacebook   = NSLocalizedString("buttonTitles.signInWithFacebook", value: "Sign in with Facebook", comment: "")
//        static let ok       = NSLocalizedString("buttonTitles.ok",      value: "OK",     comment: "")
//        static let cancel   = NSLocalizedString("buttonTitles.cancel",  value: "Cancel", comment: "")
    }
    
    struct TextFieldPlaceHolders {
        static let email    = NSLocalizedString("textFieldPlaceHolders.email", value: "Email", comment: "")
        static let password = NSLocalizedString("textFieldPlaceHolders.password", value: "Password", comment: "")
    }
    
    struct Labels {
        static let loginToUdacity = NSLocalizedString("labels.loginToUdacity", value: "Login To Udacity", comment: "")
    }
}
