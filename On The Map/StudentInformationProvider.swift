//
//  StudentInformationProvider.swift
//  On The Map
//
//  Created by Dylan Edwards on 6/15/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import Foundation

final class StudentInformationProvider {
    /// Make this a singleton
    static let sharedInstance = StudentInformationProvider()
    private init() {}
    
    internal var studentInformationArray: [StudentInformation]? {
        didSet {
            getStudentInfoCompletion?()
        }
    }
    
    private var networkRequestEngine = NetworkRequestEngine()
    
    private var getStudentInfoCompletion: (() -> Void)?
    
    //MARK: - Configuration
    internal func configure(withCompletion completion: () -> Void) {

        getStudentInfoCompletion = completion
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        
        request.addValue(Constants.Network.parseAppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.Network.restAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let requestCompletion = { (jsonDict: NSDictionary) in
            self.parseStudentInformation(jsonDict)
        }
        
        networkRequestEngine.configure(withGetDictionaryCompletion: requestCompletion, withPostCompletion: nil)
        
        networkRequestEngine.getJSONDictionary(withRequest: request)
    }
    
    //MARK: - 
    
    private func parseStudentInformation(jsonDict: NSDictionary) {
        if jsonDict["results"] != nil {
            
            guard let jsonArray = jsonDict["results"] as? [NSDictionary] else {
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
