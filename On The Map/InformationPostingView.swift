//
//  InformationPostingView.swift
//  On The Map
//
//  Created by Dylan Edwards on 6/9/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import MapKit
import UIKit

class InformationPostingView: UIView, StudentLocationRequestable {
    
    fileprivate var presentActivityIndicator: ((_ completion: (() -> Void)?) -> Void)!
    fileprivate var dismissActivityIndicator: (() -> Void)!
    fileprivate var submitSuccessfulClosure: (() -> Void)!
    fileprivate var presentErrorAlert: AlertPresentation!
    
    @IBOutlet weak var promptView: UIView!
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var bottomButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!

    @IBOutlet weak var urlTextFieldTopConstraint: NSLayoutConstraint!
    
    fileprivate var informationPostingService = InformationPostingService()
    
    fileprivate var studentInformationValues: (mapString: String, mediaURL: String, previouslyEnteredLocationObjectId: String?)? {
        didSet {
            if studentInformationValues != nil {
                mapString                           = studentInformationValues!.mapString
                mediaURL                            = studentInformationValues!.mediaURL
                previouslyEnteredLocationObjectId   = studentInformationValues!.previouslyEnteredLocationObjectId
                
                locationTextField.text  = mapString
                urlTextField.text       = mediaURL
            }
        }
    }
    
    fileprivate var previousMapString = ""
    fileprivate var mapString: String = "" {
        didSet {
            if mapString != previousMapString {
                findLocation()
            }
            previousMapString = mapString
        }
    }
    
    fileprivate var isValidLocation = false
    
    fileprivate var placemarks: [CLPlacemark]? {
        didSet {
            if placemarks != nil {
                showLocationOnMap()
            }
        }
    }
    
    fileprivate var mediaURL: String = "" {
        didSet {
            if mediaURL != "" {
                bottomButton.isEnabled = true
                if bottomButton.alpha == 0.0 {
                    animateBottomButtonIntoView()
                }
            } else {
                bottomButton.isEnabled = false
            }
        }
    }
    
    fileprivate lazy var studentInfoProvider = StudentInformationProvider.sharedInstance
    
    fileprivate var previouslyEnteredLocationObjectId: String?
    
    override func didMoveToWindow() {
        mapView.delegate = self
    }
    
    //MARK: - Configuration
    
    internal func configure(
        withActivityIndicatorPresentation presentAI: @escaping (_ completion: (() -> Void)?) -> Void,
        activityIndicatorDismissal dismissAI: @escaping () -> Void,
        successClosure success:@escaping () -> Void,
        alertPresentationClosure alertPresentation: @escaping AlertPresentation) {
        
        presentActivityIndicator    = presentAI
        dismissActivityIndicator    = dismissAI
        submitSuccessfulClosure     = success
        presentErrorAlert           = alertPresentation
        
        backgroundColor = Theme.locationSubmitScreenBGColor
        
        promptView.alpha        = 0
        promptView.transform    = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        configurePrompt()
        configureTextFields()
        configureBottomButton()
        promptViewAnimation()
        
        informationPostingService.configure(
            withActivityIndicatorPresentation: presentAI,
            activityIndicatorDismissal: dismissAI,
            successClosure: success,
            alertPresentationClosure: alertPresentation)
        
        let queryCompletion = { (studentInformationValues: (mapString: String, mediaURL: String, previouslyEnteredLocationObjectId: String?)?) in
            self.studentInformationValues = studentInformationValues
        }
        informationPostingService.queryStudentLocation(withCompletion: queryCompletion)
    }
    
    fileprivate func configurePrompt() {
        promptLabel.adjustsFontSizeToFitWidth = true
        
        let labelAttributes = [
            NSForegroundColorAttributeName: Theme.textDark,
            NSFontAttributeName: UIFont(name: Constants.FontName.avenirHeavy, size: 50)!
        ]
        var promptString = LocalizedStrings.Labels.whereAreYou
        if studentInfoProvider.currentStudent.firstName != "" {
            promptString += ", \(studentInfoProvider.currentStudent.firstName)"
        }
        promptString += "?"
        
        promptLabel.attributedText = NSAttributedString(string: promptString, attributes: labelAttributes)
    }
    
    fileprivate func configureTextFields() {
        let textFieldAttributes = [
            NSFontAttributeName: UIFont(name: Constants.FontName.avenirLight, size: 17)!,
            NSForegroundColorAttributeName: Theme.textFieldText
        ]
        
        locationTextField.defaultTextAttributes = textFieldAttributes
        locationTextField.backgroundColor       = Theme.textFieldBackground
        locationTextField.placeholder           = LocalizedStrings.TextFieldPlaceHolders.enterLocation
        locationTextField.textAlignment         = .center
        locationTextField.delegate              = self
        locationTextField.returnKeyType         = .done
        
        
        urlTextField.alpha                      = 0.0
        urlTextFieldTopConstraint.constant     -= (urlTextField.frame.height + 4)
        urlTextField.defaultTextAttributes      = textFieldAttributes
        urlTextField.backgroundColor            = Theme.textFieldBackground
        urlTextField.placeholder                = LocalizedStrings.TextFieldPlaceHolders.enterURL
        urlTextField.textAlignment              = .center
        urlTextField.delegate                   = self
        urlTextField.returnKeyType              = .done
    }

    fileprivate func configureBottomButton() {
        bottomButton.alpha                      = 0
        bottomButton.isEnabled                    = false
        bottomButton.transform                  = CGAffineTransform(scaleX: 0.5, y: 0.5)
        bottomButton.backgroundColor            = Theme.buttonBackground
        bottomButton.tintColor                  = Theme.buttonTint
        bottomButton.layer.cornerRadius         = CGFloat(6.0)
        bottomButton.titleLabel?.textAlignment  = .center
        bottomButton.contentEdgeInsets          = UIEdgeInsetsMake(5, 10, 5, 10)
        
        bottomButton.setTitle(LocalizedStrings.ButtonTitles.submit, for: UIControlState())
    }
    
    //MARK: - Actions
    
    @IBAction func bottomButtonAction(_ sender: AnyObject) {

        if !isValidLocation {
            presentErrorAlert(alertParameters: (title: LocalizedStrings.AlertTitles.locationSearchError, message: LocalizedStrings.AlertMessages.pleaseTrySearchAgain))
            
            return
        }
        
        let informationPostedCompletion = { [weak self] in
            self!.submitSuccessfulClosure()
        }
        
        if previouslyEnteredLocationObjectId != nil {
            informationPostingService.updateStudentLocation(withParameters: (mapString: mapString, mediaURL: mediaURL, placemark: placemarks![0]), previouslyEnteredLocationObjectId: previouslyEnteredLocationObjectId!, completion: informationPostedCompletion)
        } else {
            informationPostingService.postStudentLocation(withParameters: (mapString: mapString, mediaURL: mediaURL, placemark: placemarks![0]), completion: informationPostedCompletion)
        }
    }
    
    //MARK: - Map
    
    fileprivate func findLocation() {
        presentActivityIndicator(completion: nil)
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(mapString, completionHandler: { (placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            if error != nil {
                self.isValidLocation = false
                self.presentErrorAlert(alertParameters: (title: LocalizedStrings.AlertTitles.locationSearchError, message: LocalizedStrings.AlertMessages.pleaseTrySearchAgain))
                return
            } else {
                self.isValidLocation    = true
                self.placemarks         = placemarks
                self.dismissActivityIndicator()
            }
        } as! CLGeocodeCompletionHandler)
    }
    
    fileprivate func showLocationOnMap() {
        /// If this was a real app, you'd want to deal with multiple locations...
        let location            = placemarks?[0].location
        let regionRadius        = CLLocationDistance(54000)
        let coordinateRegion    = MKCoordinateRegionMakeWithDistance(location!.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        
        mapView.setRegion(coordinateRegion, animated: true)
        
        let annotation          = MKPointAnnotation()
        annotation.coordinate   = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        mapView.addAnnotation(annotation)
    }
    
    //MARK: - Animations
    
    fileprivate func promptViewAnimation() {
        UIView.animate(withDuration: 1.7, delay: 0.5, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.promptView.transform   = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.promptView.alpha       = 1.0
            }, completion: nil)
    }
    
    fileprivate func animateURLTextFieldIntoView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.urlTextFieldTopConstraint.constant += (self.urlTextField.frame.height + 4)
            self.urlTextField.alpha = 1.0
            self.layoutIfNeeded()
            }, completion: nil)
    }
    
    fileprivate func animateBottomButtonIntoView() {
        UIView.animate(withDuration: 1.7, delay: 0.5, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.bottomButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.bottomButton.alpha     = 1.0
            self.layoutIfNeeded()
            }, completion: nil)
    }
}

extension InformationPostingView: UITextFieldDelegate {
    internal func textFieldDidEndEditing(_ textField: UITextField) {
        mapString   = locationTextField.text as String! ?? ""
        mediaURL    = urlTextField.text as String! ?? ""
    }
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension InformationPostingView: MKMapViewDelegate {
    
    /// Wait for map to render before animating the url field into view
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        if urlTextField.alpha == 0 && placemarks != nil {
            animateURLTextFieldIntoView()
        }
    }
}
