//
//  AlertPresentable.swift
//  On The Map
//
//  Created by Dylan Edwards on 6/24/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

protocol AlertPresentable { }

extension AlertPresentable where Self: UIViewController {
    
    internal func presentAlertWithParameters(parameters: AlertParameters, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(
            title: parameters.title,
            message: parameters.message,
            preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: LocalizedStrings.AlertButtonTitles.ok, style: .Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
