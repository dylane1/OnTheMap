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
    
    private var studentLocationValues: (mapString: String, mediaURL: String, previouslyEnteredLocationObjectId: String?)? {
        didSet {
            if studentLocationValues != nil {
                mapString                           = studentLocationValues!.mapString
                mediaURL                            = studentLocationValues!.mediaURL
                previouslyEnteredLocationObjectId   = studentLocationValues!.previouslyEnteredLocationObjectId
            }
        }
    }
    private var mapString: String = "" {
        didSet {
            findLocation()
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
    
    private var networkRequestService = NetworkRequestService()
    
    private lazy var studentInfoProvider = StudentInformationProvider.sharedInstance
    
    private var previouslyEnteredLocationObjectId: String?
    
    //MARK: - Configuration
    
    internal func configure(
        withActivityIndicatorPresentation presentAI: (completion: (() -> Void)?) -> Void,
        activityIndicatorDismissal dismissAI: () -> Void,
        successClosure success:() -> Void,
        alertPresentationClosure alertPresentation: AlertPresentation) {
        
        magic("current student: \(studentInfoProvider.currentStudent)")
        
        presentActivityIndicator    = presentAI
        dismissActivityIndicator    = dismissAI
        submitSuccessfulClosure     = success
        presentErrorAlert           = alertPresentation
        
        promptView.alpha        = 0
        promptView.transform    = CGAffineTransformMakeScale(0.5, 0.5)
        
        mapView.delegate = self
        
        configurePrompt()
        configureTextFields()
        configureBottomButton()
        promptViewAnimation()
        
//        queryStudentLocation()
        informationPostingService.configure(withActivityIndicatorPresentation: presentAI, activityIndicatorDismissal: dismissAI, successClosure: success, alertPresentationClosure: alertPresentation)
        
        let queryCompletion = { [weak self] (locationValues: (mapString: String, mediaURL: String, previouslyEnteredLocationObjectId: String?)?) in
            self!.studentLocationValues = locationValues
        }
        informationPostingService.queryStudentLocation(withCompletion: queryCompletion)
    }
    
    private func configurePrompt() {
        promptLabel.adjustsFontSizeToFitWidth = true
        let labelAttributes = [
            NSForegroundColorAttributeName : Constants.ColorScheme.black,
            NSFontAttributeName: UIFont.systemFontOfSize(50, weight: UIFontWeightLight)
        ]
        var promptString = LocalizedStrings.Labels.whereAreYou
        if studentInfoProvider.currentStudent.firstName != "" {
            promptString += ", \(studentInfoProvider.currentStudent.firstName)"
        }
        promptString += "?"
        
        promptLabel.attributedText = NSAttributedString(string: promptString, attributes: labelAttributes)
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

    private func configureBottomButton() {
        bottomButton.alpha                      = 0
        bottomButton.enabled                    = false
        bottomButton.transform                  = CGAffineTransformMakeScale(0.5, 0.5)
        bottomButton.backgroundColor            = Constants.ColorScheme.whiteAlpha90
        bottomButton.layer.borderColor          = Constants.ColorScheme.darkBlue.CGColor
        bottomButton.layer.cornerRadius         = CGFloat(6.0)
        bottomButton.layer.borderWidth          = CGFloat(1.0)
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
            updateStudentLocation()
        } else {
            postStudentLocation()
        }
    }
    
    //TODO: This should be pulled out and into a new file
    //MARK: - Perform network requests

//    private func queryStudentLocation() {
//        magic("query location open ai")
//        let aiPresented = { [weak self] in
//            let request = self!.createStudentLocationRequest(uniqueKey: self!.studentInfoProvider.currentStudent.uniqueKey)
//            
//            let requestCompletion = { [weak self] (jsonDictionary: NSDictionary) in
//                self!.parseStudentLocationQuery(jsonDictionary)
//            }
//            
//            self!.networkRequestService.configure(withRequestCompletion: requestCompletion, requestFailedClosure: self!.presentErrorAlert)
//            self!.networkRequestService.requestJSONDictionary(withURLRequest: request)
//        }
//        presentActivityIndicator(completion: aiPresented)
//    }
    
    private func postStudentLocation() {
        let request = createStudentLocationRequest(withHTTPMethod: Constants.HTTPMethods.post)
        
        let requestCompletion = { [weak self] (jsonDictionary: NSDictionary) in
            self!.parsePostResponse(jsonDictionary)
        }
        
        performRequest(request, withCompletion: requestCompletion)
    }

    private func updateStudentLocation() {
        let request = createStudentLocationRequest(withHTTPMethod: Constants.HTTPMethods.put, objectId: previouslyEnteredLocationObjectId!)
        
        let requestCompletion = { [weak self] (jsonDictionary: NSDictionary) in
            self!.parseUpdateResponse(jsonDictionary)
        }
        
        performRequest(request, withCompletion: requestCompletion)
    }
    
    private func performRequest(request: NSMutableURLRequest, withCompletion completion: GetDictionaryCompletion) {
        
        let aiPresented = { [weak self] in
            var httpBody = "{"
            httpBody += "\"\(Constants.Keys.uniqueKey)\": \"\(self!.studentInfoProvider.currentStudent.uniqueKey)\", "
            httpBody += "\"\(Constants.Keys.firstName)\": \"\(self!.studentInfoProvider.currentStudent.firstName)\", "
            httpBody += "\"\(Constants.Keys.lastName)\": \"\(self!.studentInfoProvider.currentStudent.lastName)\", "
            httpBody += "\"\(Constants.Keys.mapString)\": \"\(self!.mapString)\", "
            httpBody += "\"\(Constants.Keys.mediaURL)\": \"\(self!.mediaURL)\", "
            httpBody += "\"\(Constants.Keys.latitude)\": \((self!.placemarks![0].location?.coordinate.latitude)!), "
            httpBody += "\"\(Constants.Keys.longitude)\": \((self!.placemarks![0].location?.coordinate.longitude)!)"
            httpBody += "}"
            
            magic(httpBody)
            request.HTTPBody = httpBody.dataUsingEncoding(NSUTF8StringEncoding)
            
            self!.networkRequestService.configure(withRequestCompletion: completion, requestFailedClosure: self!.presentErrorAlert)
            self!.networkRequestService.requestJSONDictionary(withURLRequest: request)
        }
        presentActivityIndicator(completion: aiPresented)
    }
    
    //MARK: - Parse results
    
//    private func parseStudentLocationQuery(jsonDictionary: NSDictionary) {
//        
//        guard let resultArray = jsonDictionary[Constants.Keys.results] as? NSArray,
//              let infoDict = resultArray[0] as? NSDictionary else {
//                presentErrorAlert(alertParameters: (title: LocalizedStrings.AlertTitles.locationSearchError, message: LocalizedStrings.AlertMessages.pleaseTrySearchAgain))
//            return
//        }
//        
//        studentInfoProvider.currentStudent.latitude     = infoDict[Constants.Keys.latitude] as! Double
//        studentInfoProvider.currentStudent.longitude    = infoDict[Constants.Keys.longitude] as! Double
//        studentInfoProvider.currentStudent.mapString    = infoDict[Constants.Keys.mapString] as! String
//        studentInfoProvider.currentStudent.mediaURL     = infoDict[Constants.Keys.mediaURL] as! String
//        
//        mapString   = studentInfoProvider.currentStudent.mapString
//        mediaURL    = studentInfoProvider.currentStudent.mediaURL
//        
//        previouslyEnteredLocationObjectId = infoDict[Constants.Keys.objectId] as? String
//        
//        locationTextField.text  = mapString
//        urlTextField.text       = mediaURL
//    }
    
    private func parsePostResponse(jsonDictionary: NSDictionary) {
        
        guard let _ = jsonDictionary[Constants.Keys.createdAt] as? String else {
            presentErrorAlert(alertParameters: (title: LocalizedStrings.AlertTitles.locationCreationError, message: LocalizedStrings.AlertMessages.pleaseTryAddingLocationAgain))
            return
        }
        submitSuccessfulClosure()
    }
    
    private func parseUpdateResponse(jsonDictionary: NSDictionary) {
        
        guard let _ = jsonDictionary[Constants.Keys.updatedAt] as? String else {
            presentErrorAlert(alertParameters: (title: LocalizedStrings.AlertTitles.locationUpdateError, message: LocalizedStrings.AlertMessages.pleaseTryUpdateAgain))
            return
        }
        submitSuccessfulClosure()
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
        let location = placemarks?[0].location
        let regionRadius: CLLocationDistance = 54000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location!.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        mapView.addAnnotation(annotation)
    }
    
    //MARK: - Animations
    
    private func promptViewAnimation() {
        UIView.animateWithDuration(1.7, delay: 0.5, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: .CurveEaseOut, animations: {
            self.promptView.transform = CGAffineTransformMakeScale(1.0, 1.0)
            self.promptView.alpha = 1.0
            self.layoutIfNeeded()
            }, completion: nil)
    }
    
    private func animateURLTextFieldIntoView() {
        UIView.animateWithDuration(0.5, animations: {
            self.urlTextFieldTopConstraint.constant += (self.urlTextField.frame.height + 4)
            self.urlTextField.alpha = 1.0
            self.layoutIfNeeded()
            }, completion: { (complete: Bool) in
//                self.showLocationOnMap()
            })
    }
    
    private func animateBottomButtonIntoView() {
        UIView.animateWithDuration(1.7, delay: 0.5, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: .CurveEaseOut, animations: {
            self.bottomButton.transform = CGAffineTransformMakeScale(1.0, 1.0)
            self.bottomButton.alpha = 1.0
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
        if urlTextField.alpha == 0 && placemarks != nil {
            animateURLTextFieldIntoView()
        }
    }
}























































