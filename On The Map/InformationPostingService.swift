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
    
    fileprivate var presentActivityIndicator: (((() -> Void)?) -> Void)!
    fileprivate var dismissActivityIndicator: (() -> Void)!
    fileprivate var submitSuccessfulClosure: (() -> Void)!
    fileprivate var presentErrorAlert: AlertPresentation!
    
    fileprivate var networkRequestService: NetworkRequestService?
    
    fileprivate lazy var studentInfoProvider = StudentInformationProvider.sharedInstance
    
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
    }
    
    //MARK: - Query existing location information
    
    internal func queryStudentLocation(withCompletion completion: @escaping (_ studentInformationValues: (mapString: String, mediaURL: String, previouslyEnteredLocationObjectId: String?)?) -> Void) {
        
        let aiPresented = { [weak self] in
            let request = self!.createStudentLocationRequest(uniqueKey: self!.studentInfoProvider.currentStudent.uniqueKey)
            
            let requestCompletion = { [weak self] (jsonDictionary: NSDictionary) in
                return self!.parseStudentLocationQuery(jsonDictionary, completion: completion)
            }
            
            self!.networkRequestService!.configure(withRequestCompletion: requestCompletion, requestFailedClosure: self!.presentErrorAlert)
            
            self!.networkRequestService!.requestJSONDictionary(withURLRequest: request)
        }
        
        networkRequestService = NetworkRequestService()
        presentActivityIndicator(completion: aiPresented)
    }
    
    fileprivate func parseStudentLocationQuery(_ jsonDictionary: NSDictionary, completion: (_ studentInformationValues: (mapString: String, mediaURL: String, previouslyEnteredLocationObjectId: String?)?) -> Void) {
        
        networkRequestService = nil
        
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
        
        completion((mapString!, mediaURL!, previouslyEnteredLocationObjectId))
    }
    
    //MARK: - Add a new student location / updated existing
    
    internal func postStudentLocation(withParameters params: (mapString: String, mediaURL: String, placemark: CLPlacemark), completion: (() -> Void)?) {
        let request = createStudentLocationRequest(withHTTPMethod: Constants.HTTPMethods.post)
        
        let requestCompletion = { [weak self] (jsonDictionary: NSDictionary) in
            self!.parsePostResponse(jsonDictionary)
            completion?()
        }
        
        performRequest(request, params: params, completion: requestCompletion)
    }
    
    internal func updateStudentLocation(withParameters params: (mapString: String, mediaURL: String, placemark: CLPlacemark), previouslyEnteredLocationObjectId: String, completion: (() -> Void)?) {
        
        let request = createStudentLocationRequest(withHTTPMethod: Constants.HTTPMethods.put, objectId: previouslyEnteredLocationObjectId)
        
        let requestCompletion = { [weak self] (jsonDictionary: NSDictionary) in
            self!.parseUpdateResponse(jsonDictionary)
            self!.networkRequestService = nil
            completion?()
        }
        
        performRequest(request, params: params, completion: requestCompletion)
    }
    
    fileprivate func performRequest(_ request: NSMutableURLRequest, params: (mapString: String, mediaURL: String, placemark: CLPlacemark), completion: @escaping GetDictionaryCompletion) {
        
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
            
            request.httpBody = httpBody.data(using: String.Encoding.utf8)
            
            self!.networkRequestService!.configure(withRequestCompletion: completion, requestFailedClosure: self!.presentErrorAlert)
            self!.networkRequestService!.requestJSONDictionary(withURLRequest: request)
        }
        networkRequestService = NetworkRequestService()
        presentActivityIndicator(completion: aiPresented)
    }
    
    fileprivate func parsePostResponse(_ jsonDictionary: NSDictionary) {
        
        guard let _ = jsonDictionary[Constants.Keys.createdAt] as? String else {
            presentErrorAlert((title: LocalizedStrings.AlertTitles.locationCreationError, message: LocalizedStrings.AlertMessages.pleaseTryAddingLocationAgain))
            return
        }
        submitSuccessfulClosure()
    }
    
    fileprivate func parseUpdateResponse(_ jsonDictionary: NSDictionary) {
        
        guard let _ = jsonDictionary[Constants.Keys.updatedAt] as? String else {
            presentErrorAlert(alertParameters: (title: LocalizedStrings.AlertTitles.locationUpdateError, message: LocalizedStrings.AlertMessages.pleaseTryUpdateAgain))
            return
        }
        submitSuccessfulClosure()
    }
}
