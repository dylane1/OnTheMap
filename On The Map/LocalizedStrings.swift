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
        static let onTheMap             = NSLocalizedString("ViewControllerTitles.onTheMap", value: "On The Map", comment: "")
        static let enterYourLocation    = NSLocalizedString("ViewControllerTitles.enterYourLocation", value: "Enter Your Location", comment: "")
    }
    
    struct BarButtonTitles {
        static let logout = NSLocalizedString("BarButtonTitles.logout", value: "Logout", comment: "")
    }
    
    struct ButtonTitles {
        /// Login
        static let login    = NSLocalizedString("ButtonTitles.login", value: "Login", comment: "")
        static let signInWithFacebook = NSLocalizedString("ButtonTitles.signInWithFacebook", value: "Sign in with Facebook", comment: "")
        
        /// Information Posting
        static let submit   = NSLocalizedString("ButtonTitles.submit", value: "Submit", comment: "")
    }
    
    struct TextFieldPlaceHolders {
        /// Login
        static let email            = NSLocalizedString("TextFieldPlaceHolders.email", value: "Email", comment: "")
        static let password         = NSLocalizedString("TextFieldPlaceHolders.password", value: "Password", comment: "")
        
        /// Information Posting
        static let enterLocation    = NSLocalizedString("TextFieldPlaceHolders.enterLocation", value: "Enter Location", comment: "")
        static let enterURL         = NSLocalizedString("TextFieldPlaceHolders.enterURL", value: "Enter URL", comment: "")
    }
    
    struct Labels {
        /// Login
        static let loginToUdacity   = NSLocalizedString("Labels.loginToUdacity", value: "Login To Udacity", comment: "")
        
        /// Information Posting
        static let whereAreYou      = NSLocalizedString("Labels.whereAreYou", value: "Where Are You\nStudying Today", comment: "")
    }
    
    struct AlertTitles {
        /// General error
        static let error                = NSLocalizedString("AlertTitles.error", value: "Error", comment: "")
        
        /// Reachablility error
        static let noInternetConnection = NSLocalizedString("AlertTitles.noInternetConnection", value: "No Internet Connection", comment: "")
        
        /// Login/Logout
        static let loginError           = NSLocalizedString("AlertTitles.loginError", value: "Login Error", comment: "")
        static let logoutError          = NSLocalizedString("AlertTitles.logoutError", value: "Logout Error", comment: "")
        
        /// Retrieving user info error
        static let userInfoError        = NSLocalizedString("AlertTitles.userInfoError", value: "User Fetch Error", comment: "")
        
        /// Retrieving student locations error
        static let studentLocationsError = NSLocalizedString("AlertTitles.studenLocationsError", value: "Error Finding Student Locations", comment: "")
        
        /// Geocoding error
        static let locationSearchError  = NSLocalizedString("AlertTitles.locationSearchError", value: "Location Search Error", comment: "")
        
        /// User location creation error
        static let locationCreationError  = NSLocalizedString("AlertTitles.locationCreationError", value: "Location Input Error", comment: "")
        
        /// User location update error
        static let locationUpdateError  = NSLocalizedString("AlertTitles.locationUpdateError", value: "Location Update Error", comment: "")
    }
    
    struct AlertMessages {
        /// Reachablility error
        static let connectToInternet    = NSLocalizedString("AlertMessages.userInfoError", value: "Make sure your device is connected to the internet.", comment: "")
        
        /// Login/Logout errors
        static let invalidCredentials   = NSLocalizedString("AlertMessages.invalidCredentials", value: "Account not found or invalid credentials.", comment: "")
        static let pleaseEnterUsername  = NSLocalizedString("AlertMessages.pleaseEnterUsername", value: "Please enter a valid username.", comment: "")
        static let pleaseEnterPassword  = NSLocalizedString("AlertMessages.pleaseEnterPassword", value: "Please enter a password.", comment: "")
        static let unknownLoginError    = NSLocalizedString("AlertMessages.unknownLoginError", value: "Unknown login error, please try again.", comment: "")
        static let unknownLogoutError    = NSLocalizedString("AlertMessages.unknownLogoutError", value: "Unknown logout error. Sorry :[", comment: "")
        static let serverResponded      = NSLocalizedString("AlertMessages.serverResponded", value: "The server responded with the following message:", comment: "")
        
        /// Retrieving user info error
        static let userInfoError        = NSLocalizedString("AlertMessages.userInfoError", value: "There was a problem while fetching your user data. Please try again later.", comment: "")
        
        /// Retrieving student locations error
        static let noStudentData        = NSLocalizedString("AlertMessages.noStudentData", value: "Sorry, no student location data was found on the server.", comment: "")
        
        /// Geocoding error
        static let pleaseTrySearchAgain = NSLocalizedString("AlertMessages.pleaseTrySearchAgain", value: "Unable to find your location, please enter your location again.", comment: "")
        
        /// User location creation error
        static let pleaseTryAddingLocationAgain = NSLocalizedString("AlertMessages.pleaseTryAddingLocationAgain", value: "Unable to add your location, please try again.", comment: "")
        
        /// User location update error
        static let pleaseTryUpdateAgain = NSLocalizedString("AlertMessages.pleaseTryUpdateAgain", value: "Unable to update your location, please try again.", comment: "")
    }
    
    struct AlertButtonTitles {
        static let ok = NSLocalizedString("AlertButtonTitles.ok", value: "OK", comment: "")
//        static let cancel = NSLocalizedString("AlertButtonTitles.cancel", value: "Cancel",    comment: "")
    }
}
