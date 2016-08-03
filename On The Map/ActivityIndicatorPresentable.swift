//
//  ActivityIndicatorPresentable.swift
//  On The Map
//
//  Created by Dylan Edwards on 7/6/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

protocol ActivityIndicatorPresentable: class {
    var activityIndicatorViewController: ActivityIndicatorViewController? { get set }
    var overlayTransitioningDelegate: OverlayTransitioningDelegate? { get set }
    var activityIndicatorIsPresented: Bool { get set }
}

extension ActivityIndicatorPresentable where Self: UIViewController {
    
    internal func getActivityIndicatorViewController() -> ActivityIndicatorViewController {
        
        let activityIndicatorVC = UIStoryboard(name: Constants.StoryBoardID.main, bundle: nil).instantiateViewControllerWithIdentifier(Constants.StoryBoardID.activityIndicatorVC) as! ActivityIndicatorViewController
        return activityIndicatorVC
    }
    
    internal func presentActivityIndicator(activityIndicator: ActivityIndicatorViewController, transitioningDelegate delegate: OverlayTransitioningDelegate, completion: (() -> Void)?) {
        
        activityIndicator.transitioningDelegate = delegate
        activityIndicator.modalPresentationStyle = .Custom
        
        delegate.configureTransitionWithContentSize(
            CGSizeMake(80, 80),
            options: [
                .InFromPosition : Position.Center,
                .DurationIn: 0.3,
                .AlphaIn: true,
                .ScaleIn: true,
                .OutToPosition: Position.Center,
                .DurationOut: 0.3,
                .AlphaOut: true,
                .ScaleOut: true,
                .DimmingBGColor: Theme.presentationDimBGColor
            ])
        
        activityIndicatorIsPresented = true
        presentViewController(activityIndicator, animated: true, completion: completion)
    }
    
    internal func dismissActivityIndicator(completion completion: (() -> Void)?) {
        
        dismissViewControllerAnimated(true, completion: {
            self.activityIndicatorIsPresented = false
            self.activityIndicatorViewController = nil
            self.overlayTransitioningDelegate = nil
            completion?()
        })
    }
}
