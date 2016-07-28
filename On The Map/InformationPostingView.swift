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
    
    private var presentActivityIndicator: ((completion: (() -> Void)?) -> Void)!
    private var dismissActivityIndicator: (() -> Void)!
    private var submitSuccessfulClosure: (() -> Void)!
    private var presentErrorAlert: AlertPresentation!
    
    @IBOutlet weak var promptView: UIView!
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var bottomButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!

    @IBOutlet weak var urlTextFieldTopConstraint: NSLayoutConstraint!
    
    private var informationPostingService = InformationPostingService()
    
    private var studentInformationValues: (mapString: String, mediaURL: String, previouslyEnteredLocationObjectId: String?)? {
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
    
    private var previousMapString = ""
    private var mapString: String = "" {
        didSet {
            if mapString != previousMapString {
                findLocation()
            }
            previousMapString = mapString
        }
    }
    
    private var isValidLocation = false
    
    private var placemarks: [CLPlacemark]? {
        didSet {
            if placemarks != nil {
                showLocationOnMap()
            }
        }
    }
    
    private var mediaURL: String = "" {
        didSet {
            if mediaURL != "" {
                bottomButton.enabled = true
                if bottomButton.alpha == 0.0 {
                    animateBottomButtonIntoView()
                }
            } else {
                bottomButton.enabled = false
            }
        }
    }
    
    private lazy var studentInfoProvider = StudentInformationProvider.sharedInstance
    
    private var previouslyEnteredLocationObjectId: String?
    
    override func didMoveToWindow() {
        mapView.delegate = self
    }
//    deinit { magic("\(self.description) is being deinitialized   <----------------") }
    
    //MARK: - Configuration
    
    internal func configure(
        withActivityIndicatorPresentation presentAI: (completion: (() -> Void)?) -> Void,
        activityIndicatorDismissal dismissAI: () -> Void,
        successClosure success:() -> Void,
        alertPresentationClosure alertPresentation: AlertPresentation) {
        
//        magic("current student: \(studentInfoProvider.currentStudent)")
        
        presentActivityIndicator    = presentAI
        dismissActivityIndicator    = dismissAI
        submitSuccessfulClosure     = success
        presentErrorAlert           = alertPresentation
        
        backgroundColor = Theme.locationSubmitScreenBGColor
        
        promptView.alpha        = 0
        promptView.transform    = CGAffineTransformMakeScale(0.5, 0.5)
        
        configurePrompt()
        configureTextFields()
        configureBottomButton()
        promptViewAnimation()
        
        informationPostingService.configure(
            withActivityIndicatorPresentation: presentAI,
            activityIndicatorDismissal: dismissAI,
            successClosure: success,
            alertPresentationClosure: alertPresentation)
        
        /// Initial query for existing student information
        let queryCompletion = { [weak self] (studentInformationValues: (mapString: String, mediaURL: String, previouslyEnteredLocationObjectId: String?)?) in
            self!.studentInformationValues = studentInformationValues
        }
        informationPostingService.queryStudentLocation(withCompletion: queryCompletion)
    }
    
    private func configurePrompt() {
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
    
    private func configureTextFields() {
        let textFieldAttributes = [
            NSFontAttributeName: UIFont(name: Constants.FontName.avenirLight, size: 17)!,//UIFont.systemFontOfSize(17, weight: UIFontWeightLight),
            NSForegroundColorAttributeName: Theme.textFieldText
        ]
        
        locationTextField.defaultTextAttributes = textFieldAttributes
        locationTextField.backgroundColor       = Theme.textFieldBackground
        locationTextField.placeholder           = LocalizedStrings.TextFieldPlaceHolders.enterLocation
        locationTextField.textAlignment         = .Center
        locationTextField.delegate              = self
        locationTextField.returnKeyType         = .Done
        
        
        urlTextField.alpha                      = 0.0
        urlTextFieldTopConstraint.constant     -= (urlTextField.frame.height + 4)
        urlTextField.defaultTextAttributes      = textFieldAttributes
        urlTextField.backgroundColor            = Theme.textFieldBackground
        urlTextField.placeholder                = LocalizedStrings.TextFieldPlaceHolders.enterURL
        urlTextField.textAlignment              = .Center
        urlTextField.delegate                   = self
        urlTextField.returnKeyType              = .Done
    }

    private func configureBottomButton() {
        bottomButton.alpha                      = 0
        bottomButton.enabled                    = false
        bottomButton.transform                  = CGAffineTransformMakeScale(0.5, 0.5)
        bottomButton.backgroundColor            = Theme.buttonBackground
        bottomButton.tintColor                  = Theme.buttonTint
        bottomButton.layer.cornerRadius         = CGFloat(6.0)
        bottomButton.titleLabel?.textAlignment  = .Center
        bottomButton.contentEdgeInsets          = UIEdgeInsetsMake(5, 10, 5, 10)
        
        bottomButton.setTitle(LocalizedStrings.ButtonTitles.submit, forState: .Normal)
    }
    
    //MARK: - Actions
    
    @IBAction func bottomButtonAction(sender: AnyObject) {

        if !isValidLocation {
            presentErrorAlert(alertParameters: (title: LocalizedStrings.AlertTitles.locationSearchError, message: LocalizedStrings.AlertMessages.pleaseTrySearchAgain))
            
            return
        }
        
        if previouslyEnteredLocationObjectId != nil {
            informationPostingService.updateStudentLocation(withParameters: (mapString: mapString, mediaURL: mediaURL, placemark: placemarks![0]), previouslyEnteredLocationObjectId: previouslyEnteredLocationObjectId!)
        } else {
            informationPostingService.postStudentLocation(withParameters: (mapString: mapString, mediaURL: mediaURL, placemark: placemarks![0]))
        }
    }

    
    //MARK: - Map
    
    private func findLocation() {
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
        })
    }
    
    private func showLocationOnMap() {
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
    
    private func promptViewAnimation() {
        UIView.animateWithDuration(1.7, delay: 0.5, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: .CurveEaseOut, animations: {
            self.promptView.transform   = CGAffineTransformMakeScale(1.0, 1.0)
            self.promptView.alpha       = 1.0
            }, completion: nil)
    }
    
    private func animateURLTextFieldIntoView() {
        UIView.animateWithDuration(0.5, animations: {
            self.urlTextFieldTopConstraint.constant += (self.urlTextField.frame.height + 4)
            self.urlTextField.alpha = 1.0
            self.layoutIfNeeded()
            }, completion: nil)
    }
    
    private func animateBottomButtonIntoView() {
        UIView.animateWithDuration(1.7, delay: 0.5, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: .CurveEaseOut, animations: {
            self.bottomButton.transform = CGAffineTransformMakeScale(1.0, 1.0)
            self.bottomButton.alpha     = 1.0
            self.layoutIfNeeded()
            }, completion: nil)
    }
}

extension InformationPostingView: UITextFieldDelegate {
    internal func textFieldDidEndEditing(textField: UITextField) {
        mapString   = locationTextField.text as String! ?? ""
        mediaURL    = urlTextField.text as String! ?? ""
    }
    
    internal func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension InformationPostingView: MKMapViewDelegate {
    
    /// Wait for map to render before animating the url field into view
    func mapViewDidFinishRenderingMap(mapView: MKMapView, fullyRendered: Bool) {
//        magic("fullyRendered: \(fullyRendered)")
        if urlTextField.alpha == 0 && placemarks != nil {
            animateURLTextFieldIntoView()
        }
    }
}
