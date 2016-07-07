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
    internal func getActivityIndicatorViewController(withDismissalCompletion dismissalCompletion: (() -> Void)? = nil) -> PrimaryActivityIndicatorViewController {
        let activityIndicatorViewController = UIStoryboard(name: Constants.StoryBoardID.main, bundle: nil).instantiateViewControllerWithIdentifier(Constants.StoryBoardID.primaryActivityIndicatorVC) as! PrimaryActivityIndicatorViewController
        
        activityIndicatorViewController.vcShouldBeDismissed = { [weak self] in
            self!.dismissViewControllerAnimated(false) {
                /**
                 Sets Tab bar to nil in LoginViewController
                
                 - May not need this after I track down the reason why it's not
                    getting the dealloc call upon dismissal. There's a retain
                    cycle somewhere. (more likely a bunch)
                 */
                dismissalCompletion?()
            }
        }
        return activityIndicatorViewController
    }
}

