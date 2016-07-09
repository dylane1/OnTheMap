//
//  ActivityIndicatorPresentable.swift
//  On The Map
//
//  Created by Dylan Edwards on 7/6/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

protocol ActivityIndicatorPresentable {
    var activityIndicatorViewController: PrimaryActivityIndicatorViewController? { get set }
}

extension ActivityIndicatorPresentable where Self: UIViewController {
    internal func getActivityIndicatorPresentation() -> ((() -> Void)? -> Void) {
        let presentActivityIndicator = { [weak self] (completion: (() -> Void)?) in
            if self!.activityIndicatorViewController == nil {
                self!.activityIndicatorViewController = self!.getActivityIndicatorViewController()
                self!.presentActivityIndicator(self!.activityIndicatorViewController!, completion: completion)
            }
        }
        return presentActivityIndicator
    }
    
    internal func getActivityIndicatorDismissal() -> (() -> Void) {
        let dismissActivityIndicator = { [weak self] in
            if self!.activityIndicatorViewController != nil {
                self!.dismissActivityIndicator(self!.activityIndicatorViewController!, completion: {
                    self!.activityIndicatorViewController = nil
                })
            }
        }
        return dismissActivityIndicator
    }
    
    
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

