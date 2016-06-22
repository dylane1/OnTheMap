//
//  InformationPostingView.swift
//  On The Map
//
//  Created by Dylan Edwards on 6/9/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import MapKit
import UIKit

class InformationPostingView: UIView, ParseAPIRequestable {
    enum ProgressStatus {
        case InvalidLocInvalidURL,
             InvalidLocValidURL,
             ValidLocInvalidURL,
             ValidLocValidURL
    }
    
    @IBOutlet weak var promptView: UIView!
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var bottomButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!

    
    @IBOutlet weak var urlTextFieldTopConstraint: NSLayoutConstraint!
    
    
    private var locationString: String = "" {
        didSet {
            findLocation()
        }
    }
    
    private var placemarks: [CLPlacemark]? {
        didSet {
            magic("placemarks: \(placemarks?.count)")
            if placemarks != nil {
                switch currentStatus {
                case .InvalidLocInvalidURL:
                    currentStatus = .ValidLocInvalidURL
                case .InvalidLocValidURL:
                    currentStatus = .ValidLocValidURL
                case .ValidLocInvalidURL:
                    break
                default:
                    break
                }
            }
            /// Animate the url field in
            if urlTextField.alpha != 1.0 {
                animateURLTextFieldIntoView()
            }
        }
    }
    
    private var studentURL: String = "" {
        didSet {
            if studentURL.openableURL != nil {
                switch currentStatus {
                case .InvalidLocInvalidURL:
                    currentStatus = .InvalidLocValidURL
                case .InvalidLocValidURL:
                    break
                case .ValidLocInvalidURL:
                    currentStatus = .ValidLocValidURL
                default:
                    break
                }
            }
        }
    }
    private var currentStatus: ProgressStatus = .InvalidLocInvalidURL {
        didSet {
            configureBottomButton()
        }
    }
    
    private lazy var networkConnector = NetworkRequestEngine()
    //MARK: - Configuration
    
    internal func configure() {
        promptView.alpha = 0
        promptView.transform = CGAffineTransformMakeScale(0.5, 0.5)
        
        configurePrompt()
        configureTextFields()
        configureBottomButton()
        
//        mapView.alpha = 0
        
        introAnimation()
    }
    
    private func configurePrompt() {
        promptLabel.adjustsFontSizeToFitWidth = true
        let labelAttributes = [
            NSForegroundColorAttributeName : Constants.ColorScheme.black,
            NSFontAttributeName: UIFont.systemFontOfSize(50, weight: UIFontWeightLight)
        ]
        
        promptLabel.attributedText = NSAttributedString(string: LocalizedStrings.Labels.whereAreYou, attributes: labelAttributes)
    }
    
    private func configureTextFields() {
        locationTextField.placeholder   = LocalizedStrings.TextFieldPlaceHolders.enterLocation
        locationTextField.delegate      = self
        locationTextField.returnKeyType = .Done
        
        urlTextField.alpha = 0.0
        urlTextFieldTopConstraint.constant -= (urlTextField.frame.height + 4)
        
        urlTextField.placeholder    = LocalizedStrings.TextFieldPlaceHolders.enterURL
        urlTextField.delegate       = self
        urlTextField.returnKeyType  = .Done
    }
    /**
     June 21, 2016 STOPPING POINT
     
     //TODO: Remove Show on map button & just show it when you get a [CLPlacemark]
     */
    
    
    
    
    private func configureBottomButton() {
        magic("currentStatus: \(currentStatus)")
        bottomButton.titleLabel?.textAlignment = .Center
        switch currentStatus {
        case .ValidLocValidURL:
            bottomButton.titleLabel?.text = LocalizedStrings.ButtonTitles.submit
        default:
            bottomButton.titleLabel?.text = LocalizedStrings.ButtonTitles.findOnMap
            bottomButton.enabled = (locationString == "") ? false : true
        }
    }
    
    //MARK: - Actions
    
    @IBAction func bottomButtonAction(sender: AnyObject) {
//        if currentStatus == .NotFound {
//            findLocation()
//        } else {
//            postStudentLocation()
//        }
    }
    
    //MARK: - 
    
    private func introAnimation() {
        UIView.animateWithDuration(1.7, delay: 0.5, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: .CurveEaseOut, animations: {
            self.promptView.transform = CGAffineTransformMakeScale(1.0, 1.0)
            self.promptView.alpha = 1.0
        }, completion: nil)
    }
    
    private func findLocation() {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(locationString, completionHandler: { (placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            if error != nil {
                magic("error: \(error?.localizedDescription)")
                //TODO: Pop alert
                return
            }
            self.placemarks = placemarks            
        })
    }
    
    private func showLocationOnMap() {
        if placemarks != nil {
            
        }
    }
    
    private func animateURLTextFieldIntoView() {
        UIView.animateWithDuration(0.5) /*, delay: 0.5, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .CurveEaseOut, animations: */{
            self.urlTextFieldTopConstraint.constant += (self.urlTextField.frame.height + 4)
            self.urlTextField.alpha = 1.0
            self.layoutIfNeeded()
            
        }/*, completion: nil)*/
    }
    
    private func postStudentLocation() {
        let request = getParseAPIRequest(isPostMethod: true)
        request.HTTPBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"\(locationString)\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".dataUsingEncoding(NSUTF8StringEncoding)
    }
}

extension InformationPostingView: UITextFieldDelegate {
    internal func textFieldDidEndEditing(textField: UITextField) {
        locationString = locationTextField.text as String! ?? ""
        studentURL     = urlTextField.text as String! ?? ""
    }
    
    internal func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}




































