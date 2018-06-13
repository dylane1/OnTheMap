//
//  NetworkRequestService.swift
//  On The Map
//
//  Created by Dylan Edwards on 6/15/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import Foundation

final class NetworkRequestService {
    
    fileprivate var requestCompletion: GetDictionaryCompletion!
    fileprivate var presentErrorAlert: AlertPresentation!
    
    internal func configure(withRequestCompletion reqCompletion: @escaping GetDictionaryCompletion, requestFailedClosure requestFailed: @escaping AlertPresentation) {
        requestCompletion   = reqCompletion
        presentErrorAlert   = requestFailed
    }
    
    internal func requestJSONDictionary(withURLRequest request: URLRequest, isUdacityLoginLogout uLoginLogout: Bool = false) {
        
        /// Check to see if connected to the internet first...
        if !Reachability.isConnectedToNetwork() {
            presentErrorAlert((title: LocalizedStrings.AlertTitles.noInternetConnection, message: LocalizedStrings.AlertMessages.connectToInternet))
        }
        
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            
            guard var data = data, let response = response, error == nil else {
                DispatchQueue.main.async {
                    self.presentErrorAlert((title: LocalizedStrings.AlertTitles.error, message: error!.localizedDescription))
                }
                return
            }
            
            let httpResponse = response as! HTTPURLResponse

            if httpResponse.statusCode < 200 || httpResponse.statusCode > 299 {
                magic("Error! status: \(HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))")
            }
            
            if uLoginLogout {
//                data = data.subdata(in: NSMakeRange(5, data.count - 5))
                data = data.subdata(in: 5..<data.count)
            }
            
            do {
                let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
                
                /// Get back on the main queue before returning the info
                DispatchQueue.main.async {
                    self.requestCompletion?(jsonDictionary)
                }
            }catch {
                magic("Not a JSON Dictionary :[")
//                fatalError("Not a JSON Dictionary :[")
            }
        }) 
        task.resume()
    }
    
}
