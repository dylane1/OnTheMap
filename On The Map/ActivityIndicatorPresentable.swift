//
//  ActivityIndicatorPresentable.swift
//  On The Map
//
//  Created by Dylan Edwards on 7/6/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

protocol ActivityIndicatorPresentable { }

extension ActivityIndicatorPresentable where Self: UIViewController {
    internal func getActivityIndicatorViewController() -> PrimaryActivityIndicatorViewController {
        
        let activityIndicatorViewController = UIStoryboard(name: Constants.StoryBoardID.main, bundle: nil).instantiateViewControllerWithIdentifier(Constants.StoryBoardID.primaryActivityIndicatorVC) as! PrimaryActivityIndicatorViewController
        
        return activityIndicatorViewController
    }
    
    internal func presentActivityIndicator(activityIndicator: PrimaryActivityIndicatorViewController, completion: (() -> Void)?) {
        magic("")
        self.presentViewController(activityIndicator, animated: false, completion: {
            activityIndicator.presentSecondary(withCompletion: completion)
        })
    }
    
    internal func dismissActivityIndicator(activityIndicator: PrimaryActivityIndicatorViewController, completion: (() -> Void)? = nil) {
        let dismissalCompletion = { [weak self] in
            self!.dismissViewControllerAnimated(false, completion: completion)
        }
        activityIndicator.dismissSecondary(withCompletion: dismissalCompletion)
    }
}

