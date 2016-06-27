//
//  AlertPresentable.swift
//  On The Map
//
//  Created by Dylan Edwards on 6/24/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

protocol AlertPresentable {}

extension AlertPresentable where Self: UIViewController {
    internal func getAlertPresentationClosure() -> AlertPresentationClosure {
        let alertPresentationClosure = { [unowned self] (alertTitle: String, alertMessage: String) in
            
            let alert = UIAlertController(
                title: alertTitle,
                message: alertMessage,
                preferredStyle: .Alert)
            
            alert.addAction(UIAlertAction(title: LocalizedStrings.AlertButtonTitles.ok, style: .Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
        return alertPresentationClosure
    }
}
