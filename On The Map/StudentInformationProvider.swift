//
//  StudentInformationProvider.swift
//  On The Map
//
//  Created by Dylan Edwards on 6/15/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import Foundation

final class StudentInformationProvider: StudentLocationRequestable {
    /// Make this a singleton
    static let sharedInstance = StudentInformationProvider()
    fileprivate init() {}
    
    private var informationReceivedCompletion: (() -> Void)!
    
    private var presentErrorAlert: AlertPresentation!
    
    internal var currentStudent: StudentInformation!
    
    internal var studentInformationArray: [StudentInformation]? {
        didSet {
            if studentInformationArray == nil { return }
            informationReceivedCompletion()
        }
    }
    
    fileprivate var networkRequestService = NetworkRequestService()
    
    //MARK: - Configuration
    
    /// Set after successful login
    internal func configure(withCurrentStudent student: StudentInformation) {
        currentStudent = student
    }
    
    /// Set when getting student data from server
    
    internal func configure(withInformationReceivedCompletion receivedCompletion: @escaping () -> Void, alertPresentationClosure alertPresentation: @escaping AlertPresentation) {
        
        informationReceivedCompletion   = receivedCompletion
        presentErrorAlert               = alertPresentation
        
        requestStudentInformation()
    }
    
    //MARK: - Perform network requests
    
    fileprivate func requestStudentInformation() {
        
        /// StudentLocationRequestable
        let request = createStudentLocationRequest()
        
        let requestCompletion = { [weak self] (jsonDictionary: NSDictionary) in
            self!.parseStudentInformation(jsonDictionary)
        }
        
        networkRequestService.configure(withRequestCompletion: requestCompletion, requestFailedClosure: presentErrorAlert)
        networkRequestService.requestJSONDictionary(withURLRequest: request)
    }
    
    //MARK: - Parse results
    
    fileprivate func parseStudentInformation(_ jsonDictionary: NSDictionary) {
        
        guard let studentInformationJSON = jsonDictionary[Constants.Keys.results] as? [NSDictionary] else {
            presentErrorAlert((title: LocalizedStrings.AlertTitles.studentLocationsError, message: jsonDictionary[Constants.Keys.error] as! String))
            
            return
        }
        
        if studentInformationJSON.count == 0 {
            presentErrorAlert((title: LocalizedStrings.AlertTitles.studentLocationsError, message: LocalizedStrings.AlertMessages.noStudentData))
            return
        }
        
        /// Reset for refresh
        studentInformationArray = nil
        
        var studentInfoArray = [StudentInformation]()
        
        for student in studentInformationJSON {
            let studentInfo = StudentInformation(withInfoDictionary: student)
            
            studentInfoArray.append(studentInfo)
        }
        studentInformationArray = studentInfoArray
    }
}

