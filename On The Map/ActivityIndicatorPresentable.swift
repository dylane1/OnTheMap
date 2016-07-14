//
//  ActivityIndicatorPresentable.swift
//  On The Map
//
//  Created by Dylan Edwards on 7/6/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

protocol ActivityIndicatorPresentable {
//    var activityIndicatorViewController: ActivityIndicatorViewController? { get set }
}

extension ActivityIndicatorPresentable where Self: UIViewController {
//    internal func getActivityIndicatorPresentation() -> ((() -> Void)? -> Void) {
//        let presentActivityIndicator = { [weak self] (completion: (() -> Void)?) in
//            if self!.activityIndicatorViewController == nil {
//                self!.activityIndicatorViewController = self!.getActivityIndicatorViewController()
//                self!.presentActivityIndicator(self!.activityIndicatorViewController!, completion: completion)
//            }
//        }
//        return presentActivityIndicator
//    }
    
//    internal func getActivityIndicatorDismissal() -> (() -> Void) {
//        let dismissActivityIndicator = { [weak self] in
//            if self!.activityIndicatorViewController != nil {
//                self!.dismissActivityIndicator(self!.activityIndicatorViewController!, completion: {
//                    self!.activityIndicatorViewController = nil
//                })
//            }
//        }
//        return dismissActivityIndicator
//    }
    
    
    internal func getActivityIndicatorViewController() -> ActivityIndicatorViewController {
        
        let activityIndicatorViewController = UIStoryboard(name: Constants.StoryBoardID.main, bundle: nil).instantiateViewControllerWithIdentifier(Constants.StoryBoardID.activityIndicatorVC) as! ActivityIndicatorViewController
        
        return activityIndicatorViewController
    }
    
    internal func presentActivityIndicator(/*activityIndicator: ActivityIndicatorViewController,*/ withPresentationCompletion inComplete: (() -> Void)?/*, dismissalCompletion outComplete: (() -> Void)?*/) {
        magic("")
        
        let overlayTransitioningDelegate = OverlayTransitioningDelegate(
            withPreferredContentSize: CGSizeMake(80, 80),
            dimmingBGColor: Theme03.activityIndicatorDimmingBGColor,
            cornerRadius: 6.0,
            shadowColor: Theme03.shadowDark,
            tapBackgroundToDismiss: true,/*
            presentationCompletion: inComplete,
            dismissalCompletion: outComplete,*/
            fadeInAlpha: true)
        
        let activityIndicator = self.getActivityIndicatorViewController()
        activityIndicator.transitioningDelegate = overlayTransitioningDelegate
        activityIndicator.modalPresentationStyle = .Custom
        
        presentViewController(activityIndicator, animated: true, completion: nil)
        
        
        
        
//        self.presentViewController(activityIndicator, animated: false, completion: {
//            activityIndicator.presentSecondary(withCompletion: completion)
//        })
    }
    
    internal func dismissActivityIndicator(/*activityIndicator: ActivityIndicatorViewController,*/withCompletion completion: (() -> Void)?) {
        dismissViewControllerAnimated(false, completion: completion)
//        let dismissalCompletion = { [weak self] in
//            self!.dismissViewControllerAnimated(false, completion: completion)
//        }
//        activityIndicator.dismissSecondary(withCompletion: dismissalCompletion)
    }
}

