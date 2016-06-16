//
//  StudentInformationProvider.swift
//  On The Map
//
//  Created by Dylan Edwards on 6/15/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import Foundation
//TODO: Make this a struct -- no need to make it a singleton because it's not storing data
/**
 Wait… This SHOULD store the data & be a singleton, otherwise map view & table view could have different student info arrays
 */
final class StudentInformationProvider {
    /// Make this a singleton
    static let sharedInstance = StudentInformationProvider()
    private init() {}
    
    internal var studentInformationArray: [StudentInformation]? {
        didSet {
            //magic("infos!!! \(studentInformationArray)")
        }
    }
    
    private var networkRequestEngine = NetworkRequestEngine()
    
    private var getStudentInfoCompletion: GetStudentInfoArrayCompletion?
    
    //MARK: - Configuration
    internal func configure(withCompletion completion: GetStudentInfoArrayCompletion) {

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
            
           self.getStudentInfoCompletion?(studentInfoArray)

        } else {
            magic("Something's Wrong :(")
            //TODO: pop alert
        }
    }
}
