//
//  ActivityIndicatorPresentable.swift
//  On The Map
//
//  Created by Dylan Edwards on 7/6/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

protocol ActivityIndicatorPresentable {
    var activityIndicatorViewController: ActivityIndicatorViewController? { get set }
}

extension ActivityIndicatorPresentable where Self: UIViewController {
    
    internal func getActivityIndicatorViewController() -> ActivityIndicatorViewController {
        
        let activityIndicatorViewController = UIStoryboard(name: Constants.StoryBoardID.main, bundle: nil).instantiateViewControllerWithIdentifier(Constants.StoryBoardID.activityIndicatorVC) as! ActivityIndicatorViewController
        
        return activityIndicatorViewController
    }
    
    internal func presentActivityIndicator(activityIndicator: ActivityIndicatorViewController, completion: (() -> Void)?) {
        
        let overlayTransitioningDelegate = OverlayTransitioningDelegate(
            withPreferredContentSize: CGSizeMake(80, 80),
            /*dimmingBGColor: Theme03.activityIndicatorDimmingBGColor,
            cornerRadius: 6.0,
            shadowColor: Theme03.shadowLight,
            tapBackgroundToDismiss: false,
            fadeInAlpha: true,*/
            options: [
                .InFromPosition : Position.Center
            ])
        
        activityIndicator.transitioningDelegate = overlayTransitioningDelegate
        activityIndicator.modalPresentationStyle = .Custom
        
        presentViewController(activityIndicator, animated: true, completion: completion)
    }
    
    internal func dismissActivityIndicator(completion completion: (() -> Void)?) {
        dismissViewControllerAnimated(true, completion: completion)
    }
}

