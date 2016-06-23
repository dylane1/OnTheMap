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
    
    @IBOutlet weak var promptView: UIView!
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var bottomButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    
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
                /// Animate the url field in
//                if urlTextField.alpha != 1.0 {
//                    animateURLTextFieldIntoView()
//                }
                showLocationOnMap()
            }
            
        }
    }
    
    private var studentURL: String = "" {
        didSet {
            if studentURL != "" {
                bottomButton.enabled = true
                if bottomButton.alpha == 0.0 {
                    animateBottomButtonIntoView()
                }
            } else {
                bottomButton.enabled = false
            }
        }
    }
    
    private var networkRequestEngine = NetworkRequestEngine()
    
    private lazy var studentInfoProvider = StudentInformationProvider.sharedInstance
    
    
    //MARK: - Configuration
    
    internal func configure() {
        magic("current student: \(studentInfoProvider.currentStudent)")
        promptView.alpha = 0
        promptView.transform = CGAffineTransformMakeScale(0.5, 0.5)
        
        mapView.delegate = self
        
        configurePrompt()
        configureTextFields()
        configureBottomButton()
        configureActivityIndicator()
        
        queryStudentLocation()
        introAnimation()
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
    
    private func configureActivityIndicator() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .WhiteLarge
    }
    
    //MARK: - Actions
    
    @IBAction func bottomButtonAction(sender: AnyObject) {

    }
    
    //MARK: - 
    
    private func introAnimation() {
        UIView.animateWithDuration(1.7, delay: 0.5, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: .CurveEaseOut, animations: {
            self.promptView.transform = CGAffineTransformMakeScale(1.0, 1.0)
            self.promptView.alpha = 1.0
            self.layoutIfNeeded()
        }, completion: nil)
    }
    

    private func queryStudentLocation() {
        let request = getParseAPIRequest(withUniqueKey: studentInfoProvider.currentStudent.uniqueKey)
        
        let requestCompletion = {(jsonDict: NSDictionary) in
            self.parseStudentLocationQuerey(jsonDict)
        }
        
        networkRequestEngine.configure(withGetDictionaryCompletion: requestCompletion)
        networkRequestEngine.getJSONDictionary(withRequest: request)
    }
    
    private func parseStudentLocationQuerey(jsonDict: NSDictionary) {
        let resultArray = jsonDict["results"] as! NSArray
        magic("resultArray.count: \(resultArray.count)")
        
        if resultArray.count == 0 { return }
        
        //FIXME:
        /**
          Going to run into problems with didSet {} in the vars...
         */
        /// if success: make a CLPlacemark
        //        let placeMark = CLPlacemark()
        //        placeMark.location = CLLocation(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)
        
        /// populate text fields
    }
    
    
    private func findLocation() {
        activityIndicator.startAnimating()
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(locationString, completionHandler: { (placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            if error != nil {
                magic("error: \(error?.localizedDescription)")
                //TODO: Pop alert
                
            } else {
                self.placemarks = placemarks
            }
            self.activityIndicator.stopAnimating()
        })
    }
    
    private func showLocationOnMap() {
        //TODO: Deal with multiple locations
        let location = placemarks?[0].location
        let regionRadius: CLLocationDistance = 54000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location!.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        mapView.addAnnotation(annotation)
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
    
    
    
    
    
    
    
    
    private func postStudentLocation() {
        let request = getParseAPIRequest(isPostMethod: true)
        var httpBody = "{"
        httpBody += "\"uniqueKey\": \"\(studentInfoProvider.currentStudent.uniqueKey)\", "
        httpBody += "\"firstName\": \"\(studentInfoProvider.currentStudent.firstName)\", "
        httpBody += "\"lastName\": \"\(studentInfoProvider.currentStudent.lastName)\", "
        httpBody += "\"mapString\": \"\(locationString)\", "
        httpBody += "\"mediaURL\": \"\(studentURL)\", "
        httpBody += "\"latitude\": \(placemarks![0].location?.coordinate.latitude), "
        httpBody += "\"longitude\": \(placemarks![0].location?.coordinate.longitude)}"
        
        request.HTTPBody = httpBody.dataUsingEncoding(NSUTF8StringEncoding)
    }
    
    private func updateStudentLocation() {
        
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

extension InformationPostingView: MKMapViewDelegate {
    
    /// Wait for map to render before animating the url field into view
    func mapViewDidFinishRenderingMap(mapView: MKMapView, fullyRendered: Bool) {
        if urlTextField.alpha == 0 && placemarks != nil {
            animateURLTextFieldIntoView()
        }
    }
}























































