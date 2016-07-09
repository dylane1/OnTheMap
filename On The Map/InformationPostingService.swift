//
//  InformationPostingService.swift
//  On The Map
//
//  Created by Dylan Edwards on 7/8/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import MapKit
import UIKit

final class InformationPostingService: StudentLocationRequestable {
    
    private var presentActivityIndicator: ((completion: (() -> Void)?) -> Void)!
    private var dismissActivityIndicator: (() -> Void)!
    private var submitSuccessfulClosure: (() -> Void)!
    private var presentErrorAlert: AlertPresentation!
    
    
    private var networkRequestService = NetworkRequestService()
    
    private lazy var studentInfoProvider = StudentInformationProvider.sharedInstance
    
//    private var previouslyEnteredLocationObjectId: String?
    
//    private var
    //MARK: - Configuration
    
    internal func configure(
        withActivityIndicatorPresentation presentAI: (completion: (() -> Void)?) -> Void,
        activityIndicatorDismissal dismissAI: () -> Void,
        successClosure success:() -> Void,
        alertPresentationClosure alertPresentation: AlertPresentation) {
        
        presentActivityIndicator    = presentAI
        dismissActivityIndicator    = dismissAI
        submitSuccessfulClosure     = success
        presentErrorAlert           = alertPresentation
    }
    
    
    
    //TODO: This should be pulled out and into a new file
    //MARK: - Perform network requests
    
    internal func queryStudentLocation(withCompletion completion: (locationValues: (mapString: String, mediaURL: String, previouslyEnteredLocationObjectId: String?)?) -> Void) {
        
        let aiPresented = { [weak self] in
            let request = self!.createStudentLocationRequest(uniqueKey: self!.studentInfoProvider.currentStudent.uniqueKey)
            
            let requestCompletion = { [weak self] (jsonDictionary: NSDictionary) in
                return self!.parseStudentLocationQuery(jsonDictionary, completion: completion)
            }
            
            self!.networkRequestService.configure(withRequestCompletion: requestCompletion, requestFailedClosure: self!.presentErrorAlert)
            self!.networkRequestService.requestJSONDictionary(withURLRequest: request)
        }
        presentActivityIndicator(completion: aiPresented)
    }
    
//    private func postStudentLocation(withParameters params: (mapString: String, mediaURL: String, placemark: CLPlacemark)) {
//        let request = createStudentLocationRequest(withHTTPMethod: Constants.HTTPMethods.post)
//        
//        let requestCompletion = { [weak self] (jsonDictionary: NSDictionary) in
//            self!.parsePostResponse(jsonDictionary)
//        }
//        
//        performRequest(request, params: params, completion: requestCompletion)
//    }
    
//    private func updateStudentLocation(withParameters params: (mapString: String, mediaURL: String, placemark: CLPlacemark)) {
//        let request = createStudentLocationRequest(withHTTPMethod: Constants.HTTPMethods.put, objectId: previouslyEnteredLocationObjectId!)
//        
//        let requestCompletion = { [weak self] (jsonDictionary: NSDictionary) in
//            self!.parseUpdateResponse(jsonDictionary)
//        }
//        
//        performRequest(request, params: params, completion: requestCompletion)
//    }
    
    private func performRequest(request: NSMutableURLRequest, params: (mapString: String, mediaURL: String, placemark: CLPlacemark), completion: GetDictionaryCompletion) {
        
        let aiPresented = { [weak self] in
            var httpBody = "{"
            httpBody += "\"\(Constants.Keys.uniqueKey)\": \"\(self!.studentInfoProvider.currentStudent.uniqueKey)\", "
            httpBody += "\"\(Constants.Keys.firstName)\": \"\(self!.studentInfoProvider.currentStudent.firstName)\", "
            httpBody += "\"\(Constants.Keys.lastName)\": \"\(self!.studentInfoProvider.currentStudent.lastName)\", "
            httpBody += "\"\(Constants.Keys.mapString)\": \"\(params.mapString)\", "
            httpBody += "\"\(Constants.Keys.mediaURL)\": \"\(params.mediaURL)\", "
            httpBody += "\"\(Constants.Keys.latitude)\": \((params.placemark.location?.coordinate.latitude)!), "
            httpBody += "\"\(Constants.Keys.longitude)\": \((params.placemark.location?.coordinate.longitude)!)"
            httpBody += "}"
            
            magic(httpBody)
            request.HTTPBody = httpBody.dataUsingEncoding(NSUTF8StringEncoding)
            
            self!.networkRequestService.configure(withRequestCompletion: completion, requestFailedClosure: self!.presentErrorAlert)
            self!.networkRequestService.requestJSONDictionary(withURLRequest: request)
        }
        presentActivityIndicator(completion: aiPresented)
    }
    
    //MARK: - Parse results
    
    private func parseStudentLocationQuery(jsonDictionary: NSDictionary, completion: (locationValues: (mapString: String, mediaURL: String, previouslyEnteredLocationObjectId: String?)?) -> Void) {
        
        guard let resultArray = jsonDictionary[Constants.Keys.results] as? NSArray,
            let infoDict = resultArray[0] as? NSDictionary else {
                presentErrorAlert(alertParameters: (title: LocalizedStrings.AlertTitles.locationSearchError, message: LocalizedStrings.AlertMessages.pleaseTrySearchAgain))
                return
        }
        
        studentInfoProvider.currentStudent.latitude     = infoDict[Constants.Keys.latitude] as! Double
        studentInfoProvider.currentStudent.longitude    = infoDict[Constants.Keys.longitude] as! Double
        studentInfoProvider.currentStudent.mapString    = infoDict[Constants.Keys.mapString] as! String
        studentInfoProvider.currentStudent.mediaURL     = infoDict[Constants.Keys.mediaURL] as! String
        
        let mapString   = studentInfoProvider.currentStudent.mapString
        let mediaURL    = studentInfoProvider.currentStudent.mediaURL
        
        let previouslyEnteredLocationObjectId = infoDict[Constants.Keys.objectId] as? String
        
        completion(locationValues: (mapString, mediaURL, previouslyEnteredLocationObjectId))
    }
    
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
    
//    private func findLocation(withMapString mapString: String) -> (isValidLocation: Bool, placemarks: [CLPlacemark]?) {
//        presentActivityIndicator(completion: nil)
//        
//        var isValidLocation = false
//        let geocoder = CLGeocoder()
//        geocoder.geocodeAddressString(mapString, completionHandler: { (placemarks: [CLPlacemark]?, error: NSError?) -> Void in
//            if error != nil {
////                self.isValidLocation = false
//                self.presentErrorAlert(alertParameters: (title: LocalizedStrings.AlertTitles.locationSearchError, message: LocalizedStrings.AlertMessages.pleaseTrySearchAgain))
//                return
//            } else {
//                isValidLocation = true
//                self.placemarks         = placemarks
//                self.dismissActivityIndicator()
//            }
//        })
//    }
}