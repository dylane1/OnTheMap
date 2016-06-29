//
//  StudentInformationProvider.swift
//  On The Map
//
//  Created by Dylan Edwards on 6/15/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import Foundation

final class StudentInformationProvider: StudentInformationGettable, ParseAPIRequestable {
    /// Make this a singleton
    static let sharedInstance = StudentInformationProvider()
    private init() {}
    
    internal var currentStudent: StudentInformation!
    
    internal var studentInformationArray: [StudentInformation]? {
        didSet {
            informationReceivedCompletion?()
        }
    }
    
    private var networkRequestService = NetworkRequestService()
    
    private var informationReceivedCompletion: (() -> Void)?
    private var alertPresentationClosure: AlertPresentationClosure?
    
    //MARK: - Configuration
    
    /// Set after successful login
    internal func configure(withCurrentStudent student: StudentInformation) {
        currentStudent = student
    }
    
    /// Set when getting student data from server
    internal func configure(withInformationReceivedCompletion receivedCompletion: () -> Void, alertPresentationClosure alertClosure: AlertPresentationClosure) {

        informationReceivedCompletion   = receivedCompletion
        alertPresentationClosure        = alertClosure
        
        let request = getParseAPIRequest()
        
        let requestCompletion = { (jsonDictionary: NSDictionary) in
            self.parseStudentInformation(jsonDictionary)
        }
        
        networkRequestService.configure(withRequestCompletion: requestCompletion, alertPresentationClosure: alertPresentationClosure!)
        networkRequestService.requestJSONDictionary(withURLRequest: request)
    }
    
    //MARK: - 
    
    private func parseStudentInformation(jsonDictionary: NSDictionary) {
        if jsonDictionary[Constants.Keys.results] != nil {
            
            guard let jsonArray = jsonDictionary[Constants.Keys.results] as? [NSDictionary] else {
                magic("no :(")
                return
            }
            
            var studentInfoArray = [StudentInformation]()
            
            for student in jsonArray {
                let studentInfo = StudentInformation(withInfoDictionary: student)
                
                studentInfoArray.append(studentInfo)
            }
            
            self.studentInformationArray = studentInfoArray

        } else {
            magic("Something's Wrong :(")
            //TODO: pop alert
        }
    }
}
