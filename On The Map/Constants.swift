//
//  Constants.swift
//  On The Map
//
//  Created by Dylan Edwards on 5/18/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

struct Constants {
    /// Storyboard
    struct StoryBoardID {
        static let main                     = "Main"
        static let loginVC                  = "loginVC"
        static let activityIndicatorVC      = "activityIndicatorVC"
        static let mapPresentationVC        = "mapPresentationVC"
        static let infoPostingNavController = "infoPostingNavController"
        static let infoPostingVC            = "infoPostingVC"
    }
    
    /// UI
    struct ColorScheme {
        static let white        = UIColor(red: 0.969, green: 0.969, blue: 0.941, alpha: 1.00) //F7F7F0
        static let whiteAlpha50 = UIColor(red: 0.969, green: 0.969, blue: 0.941, alpha: 0.50)
//        static let whiteAlpha70 = UIColor(red: 0.969, green: 0.969, blue: 0.941, alpha: 0.70)
        static let whiteAlpha90 = UIColor(red: 0.969, green: 0.969, blue: 0.941, alpha: 0.90)
        static let lightGrey    = UIColor(red: 0.796, green: 0.796, blue: 0.796, alpha: 1.00) //CBCBCB
//        static let mediumGrey   = UIColor(red: 0.409, green: 0.409, blue: 0.409, alpha: 1.00)
//        static let darkGrey     = UIColor(red: 0.149, green: 0.149, blue: 0.149, alpha: 1.00) //262626
//        static let darkBlueGrey = UIColor(red: 0.200, green: 0.300, blue: 0.310, alpha: 1.00) //324D4E
        static let black        = UIColor(red: 0.010, green: 0.010, blue: 0.010, alpha: 1.00)
//        static let lightBlue    = UIColor(red: 0.243, green: 0.733, blue: 0.655, alpha: 1.00) //3EBBA7
//        static let mediumBlue   = UIColor(red: 0.000, green: 0.560, blue: 0.590, alpha: 1.00) //008F97
        static let darkBlue     = UIColor(red: 0.000, green: 0.455, blue: 0.478, alpha: 1.00) //00747A
        static let veryDarkBlue = UIColor(red: 0.000, green: 0.150, blue: 0.160, alpha: 1.00) //002729
        static let orange       = UIColor(red: 1.000, green: 0.616, blue: 0.200, alpha: 1.00) //FF9D33
        static let red          = UIColor(red: 0.800, green: 0.200, blue: 0.200, alpha: 1.00) //CC3333
//        static let green        = UIColor(red: 0.494, green: 0.827, blue: 0.129, alpha: 1.00) //7ED321
//        static let purple       = UIColor(red: 0.294, green: 0.180, blue: 0.631, alpha: 1.00) //4B2EA1
//        static let yellow       = UIColor(red: 0.898, green: 0.792, blue: 0.090, alpha: 1.00) //E5CA17
    }
    
    struct ScreenHeight {
        static let iPhone4s: CGFloat    = 480
        static let iPhone5: CGFloat     = 568
        static let iPhone6: CGFloat     = 667
        static let iPhone6Plus: CGFloat = 736
    }
    
    struct MapImage {
        static let iPhone4s     = "Map_iPhone4s.png"
        static let iPhone5      = "Map_iPhone5.png"
        static let iPhone6      = "Map_iPhone6.png"
        static let iPhone6Plus  = "Map_iPhone6Plus.png"
    }
    //MARK: - Network
    
    struct Network {
        static let udacitySessionURL    = "https://www.udacity.com/api/session"
        static let parseAppID           = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let restAPIKey           = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
    struct HTTPHeaderFieldValues {
        static let applicationJSON = "application/json"
    }
    
    struct HTTPHeaderFields {
        static let accept           = "Accept"
        static let contentType      = "Content-Type"
        static let xParseAppId      = "X-Parse-Application-Id"
        static let xParseRestAPIKey = "X-Parse-REST-API-Key"
    }
    
    struct HTTPMethods {
        static let get      = "GET"
        static let post     = "POST"
        static let put      = "PUT"
        static let delete   = "DELETE"
    }
    struct Testing {
        static let myValidUsername = "dylan.e3@gmail.com"
        static let myValidPassword = "*8Kjp4uGouIZ:d{*yM07l"
    }
    
    struct FontName {
//        static let americanTypewriter   = "AmericanTypewriter-Bold"
//        static let arial                = "Arial-BoldMT"
        static let avenir               = "Avenir-Black"
//        static let avenirNext           = "AvenirNext-Heavy"
//        static let avenirNextCondensed  = "AvenirNextCondensed-Heavy"
//        static let copperplate          = "Copperplate-Bold"
//        static let futura               = "Futura-CondensedExtraBold"
//        static let gillSans             = "GillSans-Bold"
//        static let hoeflerText          = "HoeflerText-Black"
//        static let impact               = "Impact"
        static let markerFelt           = "MarkerFelt-Wide"
    }


    //MARK: - Dictionary Keys
    
    struct Keys {
        ///
        static let session      = "session"
        static let account      = "account"
        static let id           = "id"
        
        ///
        static let key          = "key"
        static let user         = "user"
        
        ///
        static let first_name   = "first_name"
        static let last_name    = "last_name"
        
        ///
        static let results      = "results"
        static let objectId     = "objectId"
        static let firstName    = "firstName"
        static let lastName     = "lastName"
        static let uniqueKey    = "uniqueKey"
        static let latitude     = "latitude"
        static let longitude    = "longitude"
        static let mapString    = "mapString"
        static let mediaURL     = "mediaURL"
        static let updatedAt    = "updatedAt"
        static let createdAt    = "createdAt"
        
        ///
        static let status       = "status"
        static let error        = "error"
        static let parameter    = "parameter"
    }
    
    struct LoginErrorResponses {
        static let missingUsername = "udacity.username"
        static let missingPassword = "udacity.password"
    }

}
