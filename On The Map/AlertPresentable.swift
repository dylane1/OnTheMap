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
    internal func getAlertPresentationClosure() -> AlertPresentationClosureWithParameters {
        let alertPresentationClosureWithParameters = { [unowned self] (alertParameters: AlertParameters) in
            
            /// Close any presented view controllers (Activity Indicator)
            /// NOTE: This may hose Tab bar & Info input vc
            self.dismissViewControllerAnimated(false, completion: {
                let alert = UIAlertController(
                    title: alertParameters.title,
                    message: alertParameters.message,
                    preferredStyle: .Alert)
                
                alert.addAction(UIAlertAction(title: LocalizedStrings.AlertButtonTitles.ok, style: .Default, handler: nil))
                
                self.presentViewController(alert, animated: true, completion: nil)
            })
            
        }
        return alertPresentationClosureWithParameters
    }
}
