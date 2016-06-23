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
            getStudentInfoCompletion?()
        }
    }
    
    private var networkRequestService = NetworkRequestService()
    
    private var getStudentInfoCompletion: (() -> Void)?
    
    //MARK: - Configuration
    
    /// Set after successful login
    internal func configure(withCurrentStudent student: StudentInformation) {
        currentStudent = student
    }
    
    /// Set when getting student data from server
    internal func configure(withCompletion completion: () -> Void) {

        getStudentInfoCompletion = completion
        
        let request = getParseAPIRequest()
        
        let requestCompletion = { (jsonDict: NSDictionary) in
            self.parseStudentInformation(jsonDict)
        }
        
        networkRequestService.configure(withRequestCompletion: requestCompletion)
        networkRequestService.requestJSONDictionary(withURLRequest: request)
    }
    
    //MARK: - 
    
    private func parseStudentInformation(jsonDict: NSDictionary) {
        if jsonDict[Constants.Keys.results] != nil {
            
            guard let jsonArray = jsonDict[Constants.Keys.results] as? [NSDictionary] else {
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
