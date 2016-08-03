//
//  AlertPresentable.swift
//  On The Map
//
//  Created by Dylan Edwards on 6/24/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit


protocol AlertPresentable/*: class*/ {}

extension AlertPresentable where Self: UIViewController, Self: ActivityIndicatorPresentable {
    /**
     Not sure how I feel about Self being forced to conform to ActivityIndicatorPresentable...
     
     However, if there is an activity indicator present, it must be dismissed
     before the alert can be presented.
     */
    
    internal func getAlertPresentation() -> ((AlertParameters) -> Void){
        
        let presentErrorAlert = { [weak self] (parameters: AlertParameters) in
            if self!.activityIndicatorIsPresented {
                let dismissalCompletion = { [weak self] in
                    self!.presentAlertWithParameters(parameters)
                }
                self!.dismissActivityIndicator(completion: dismissalCompletion)
            } else {
                self!.presentAlertWithParameters(parameters)
            }
        }
        return presentErrorAlert
    }
    
    internal func presentAlertWithParameters(parameters: AlertParameters, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(
            title: parameters.title,
            message: parameters.message,
            preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: LocalizedStrings.AlertButtonTitles.ok, style: .Default, handler: nil))
        
        presentViewController(alert, animated: true, completion: nil)
    }
}
