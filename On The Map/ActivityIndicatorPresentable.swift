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
        
        let overlayTransitioningDelegate = OverlayTransitioningDelegate()
        
        activityIndicator.transitioningDelegate = overlayTransitioningDelegate
        activityIndicator.modalPresentationStyle = .Custom
        
        //TODO: Can I make this a class func like UIView.animateWithDuration() ?
        overlayTransitioningDelegate.configureTransitionWithContentSize(CGSizeMake(80, 80), options: [
                                                                    .InFromPosition : Position.Center,
                                                                    .DurationIn: 0.3,
                                                                    .AlphaIn: true,
                                                                    .ScaleIn: true,
                                                                    .OutToPosition: Position.Center,
                                                                    .DurationOut: 0.3,
                                                                    .AlphaOut: true,
                                                                    .ScaleOut: true,
                                                                    .DimmingBGColor: Theme03.activityIndicatorDimmingBGColor
            ])
        presentViewController(activityIndicator, animated: true, completion: completion)
    }
    
    internal func dismissActivityIndicator(completion completion: (() -> Void)?) {
        dismissViewControllerAnimated(true, completion: completion)
    }
}

