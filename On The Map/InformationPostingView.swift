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
    
    
    private var mapString: String = "" {
        didSet {
            findLocation()
        }
    }
    private var isValidLocation = false
    
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
    
    private var objectId: String?
    
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
        
        promptViewAnimation()
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
        /**
         Stopping point June 23, 2016
        
         If invalid location, need to pop alert
        */
        
        
        
        
        if objectId != nil {
            updateStudentLocation()
        } else {
            postStudentLocation()
        }
    }
    
    //MARK: - 

    private func queryStudentLocation() {
        let request = getParseAPIRequest(withUniqueKey: studentInfoProvider.currentStudent.uniqueKey)
        
        let requestCompletion = { (jsonDict: NSDictionary) in
            self.parseStudentLocationQuery(jsonDict)
        }
        
        networkRequestService.configure(withRequestCompletion: requestCompletion)
        networkRequestService.requestJSONDictionary(withURLRequest: request)
    }
    
    private func parseStudentLocationQuery(jsonDict: NSDictionary) {
        let resultArray = jsonDict[Constants.Keys.results] as! NSArray
//        magic("resultArray: \(resultArray)")
        
        if resultArray.count == 0 { return }
        
        let infoDict = resultArray[0] as! NSDictionary
        
        studentInfoProvider.currentStudent.latitude     = infoDict[Constants.Keys.latitude] as! Double
        studentInfoProvider.currentStudent.longitude    = infoDict[Constants.Keys.longitude] as! Double
        studentInfoProvider.currentStudent.mapString    = infoDict[Constants.Keys.mapString] as! String
        studentInfoProvider.currentStudent.mediaURL     = infoDict[Constants.Keys.mediaURL] as! String
        
        magic("updated currentStudent: \(studentInfoProvider.currentStudent)")
        
        mapString   = studentInfoProvider.currentStudent.mapString
        mediaURL    = studentInfoProvider.currentStudent.mediaURL
        objectId    = infoDict[Constants.Keys.objectId] as? String
        
        locationTextField.text  = mapString
        urlTextField.text       = mediaURL
        
        /*
         createdAt = "2016-06-23T18:59:54.358Z";
         firstName = Dylan;
         lastName = Edwards;
         latitude = "44.052153";
         longitude = "-123.091195";
         mapString = "Eugene Oregon";
         mediaURL = "http://www.dylan.photos";
         objectId = B7YT82FF8T;
         uniqueKey = u20327308;
         updatedAt = "2016-06-23T18:59:54.358Z";
         */
    }
    
    private func postStudentLocation() {
        
        let requestCompletion = { (jsonDict: NSDictionary) in
            self.parsePostResponse(jsonDict)
        }
        let request = getParseAPIRequest(isPostMethod: true)
        
        performRequest(request, withCompletion: requestCompletion)
    }
    
    
    
    private func updateStudentLocation() {
        let requestCompletion = { (jsonDict: NSDictionary) in
            self.parseUpdateResponse(jsonDict)
        }
        let request = getParseAPIRequest(isPutMethod: true, withObjectId: objectId!)
        
        performRequest(request, withCompletion: requestCompletion)
    }
    
    private func performRequest(request: NSMutableURLRequest, withCompletion completion: GetDictionaryCompletion) {
        
        var httpBody = "{"
        httpBody += "\"\(Constants.Keys.uniqueKey)\": \"\(studentInfoProvider.currentStudent.uniqueKey)\", "
        httpBody += "\"\(Constants.Keys.firstName)\": \"\(studentInfoProvider.currentStudent.firstName)\", "
        httpBody += "\"\(Constants.Keys.lastName)\": \"\(studentInfoProvider.currentStudent.lastName)\", "
        httpBody += "\"\(Constants.Keys.mapString)\": \"\(mapString)\", "
        httpBody += "\"\(Constants.Keys.mediaURL)\": \"\(mediaURL)\", "
        //TODO: use these to test invalid json error handling
        httpBody += "\"\(Constants.Keys.latitude)\": \((placemarks![0].location?.coordinate.latitude)!), "
        httpBody += "\"\(Constants.Keys.longitude)\": \((placemarks![0].location?.coordinate.longitude)!)}"
        
        magic(httpBody)
        request.HTTPBody = httpBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        networkRequestService.configure(withRequestCompletion: completion)
        networkRequestService.requestJSONDictionary(withURLRequest: request)
    }
    
    
    
    private func parsePostResponse(jsonDict: NSDictionary) {
        magic("postDict: \(jsonDict)")
    }
    
    private func parseUpdateResponse(jsonDict: NSDictionary) {
        magic("updateDict: \(jsonDict)")
    }
    
    
    
    private func findLocation() {
        activityIndicator.startAnimating()
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(mapString, completionHandler: { (placemarks: [CLPlacemark]?, error: NSError?) -> Void in
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
        magic("")
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























































