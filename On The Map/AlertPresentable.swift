//
//  AlertPresentable.swift
//  On The Map
//
//  Created by Dylan Edwards on 6/24/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

protocol AlertPresentable { }

extension AlertPresentable where Self: UIViewController, Self: ActivityIndicatorPresentable {
    /**
     Not sure how I feel about Self being forced to conform to ActivityIndicatorPresentable...
     
     However, if there is an activity indicator present, it must be dismissed
     before the alert can be presented. Maybe if I pass the ai reference into 
     the function:
     
     let presentErrorAlert = { [weak self] (aiToDismiss: PrimaryActivityIndicatorController, parameters: AlertParameters) in .... }
     */
    internal func getAlertPresentation() -> ((AlertParameters) -> Void){
        let presentErrorAlert = { [weak self] (parameters: AlertParameters) in
            let dismissalCompletion = { [weak self] in
                self!.activityIndicatorViewController = nil
                self!.presentAlertWithParameters(parameters)
            }
            if self!.activityIndicatorViewController != nil {
                self!.dismissActivityIndicator(self!.activityIndicatorViewController!, completion: dismissalCompletion)
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
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
