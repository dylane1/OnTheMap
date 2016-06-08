//
//  LoginValidation.swift
//  On The Map
//
//  Created by Dylan Edwards on 5/25/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import Foundation

final class LoginValidation {
    
    enum Error: ErrorType {
        case InvalidJSON
    }
    
    private var udacitySuccessfulLogin: LoginSuccess!
    
    private var dataToParse: NSData? {
        didSet {
            parse(fromData: dataToParse!)
        }
    }
    
    //MARK: - Configuration
    internal func configure(withSuccessClosure closure: LoginSuccess) {
        udacitySuccessfulLogin = closure
    }
    
    //MARK: - Network connect
    
    internal func verifyLogin(withEmail email: String, password: String) {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        
        let session = NSURLSession.sharedSession()
        
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            /**
             LoginValidation.verifyLogin(withEmail:password:)[43]: response status code: forbidden
             */
            let httpResponse = response as! NSHTTPURLResponse
            magic("response status code: \(NSHTTPURLResponse.localizedStringForStatusCode(httpResponse.statusCode))")
            
            if error != nil {
                magic("\(error!.localizedDescription)")
                let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                magic("Could not parse JSON: \(jsonStr)")
                return
            }
            
            guard let data = data else { return }
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            
            self.dataToParse = newData
        }
        
        task.resume()
    }
    
    //MARK: - Parse JSON
    
    private func parse(fromData data: NSData) {
        
        
        guard let jsonDict = try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! [String : AnyObject] else {
            magic("INVALID JSON!!!")
            return
        }
        parseThatJSON(jsonDict)
    }
    
    
    private func parseThatJSON(jsonDict: [String : AnyObject]) {
//        magic("json: \(jsonDict)")
        
        
        if jsonDict["session"] != nil {
            dispatch_async(dispatch_get_main_queue()) {
                self.udacitySuccessfulLogin()
            }
            
        } else {
            magic("Invalid login")
            //TODO: pop alert
        }
    }
}



/**
 * Sample response:
 
 {
 "account":{
 "registered":true,
 "key":"3903878747"
 },
 "session":{
 "id":"1457628510Sc18f2ad4cd3fb317fb8e028488694088",
 "expiration":"2015-05-10T16:48:30.760460Z"
 }
 }
 */

/**
 * Real Response:
 [
 "session": {
 expiration = "2016-08-02T00:11:08.171300Z";
 id = 1496448668S91843fdbda6e2232a715d7e82fcf19df;
 },
 "account": {
 key = u20327308;
 registered = 1;
 }
 ]
 
 * Invalid login:
 LoginValidation.parseThatJSON[74]: json:
 [
 "status": 403,
 "error": Account not found or invalid credentials.
 ]
 */ 






































