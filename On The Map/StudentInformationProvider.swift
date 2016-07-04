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
    private init() {}
    
    private var informationReceivedCompletion: (() -> Void)?
    private var alertPresentationClosureWithParameters: AlertPresentationClosureWithParameters?
    
    internal var currentStudent: StudentInformation!
    
    internal var studentInformationArray: [StudentInformation]? {
        didSet {
            informationReceivedCompletion?()
        }
    }
    
    private var networkRequestService = NetworkRequestService()
    
    //MARK: - Configuration
    
    /// Set after successful login
    internal func configure(withCurrentStudent student: StudentInformation) {
        currentStudent = student
    }
    
    /// Set when getting student data from server
    internal func configure(withInformationReceivedCompletion receivedCompletion: () -> Void, alertPresentationClosure alertClosure: AlertPresentationClosureWithParameters) {

        informationReceivedCompletion           = receivedCompletion
        alertPresentationClosureWithParameters  = alertClosure
        
        requestStudentInformation()
    }
    
    //MARK: - Perform network requests
    
    private func requestStudentInformation() {
        let request = createStudentLocationRequest()
        
        let requestCompletion = { [weak self] (jsonDictionary: NSDictionary) in
            self!.parseStudentInformation(jsonDictionary)
        }
        
        networkRequestService.configure(withRequestCompletion: requestCompletion, alertPresentationClosure: alertPresentationClosureWithParameters!)
        networkRequestService.requestJSONDictionary(withURLRequest: request)
    }
    
    //MARK: - Parse results
    
    private func parseStudentInformation(jsonDictionary: NSDictionary) {
//        magic("jsonDictionary: \(jsonDictionary)")
        guard let studentInformationJSON = jsonDictionary[Constants.Keys.results] as? [NSDictionary] else {
            alertPresentationClosureWithParameters?((title: LocalizedStrings.AlertTitles.studentLocationsError, message: jsonDictionary[Constants.Keys.error] as! String))
            
            return
        }
        
        if studentInformationJSON.count == 0 {
            alertPresentationClosureWithParameters?((title: LocalizedStrings.AlertTitles.studentLocationsError, message: LocalizedStrings.AlertMessages.noStudentData))
        }
        
        var studentInfoArray = [StudentInformation]()
        
        for student in studentInformationJSON {
            let studentInfo = StudentInformation(withInfoDictionary: student)
            
            studentInfoArray.append(studentInfo)
        }
        
        self.studentInformationArray = studentInfoArray
    }
}







































