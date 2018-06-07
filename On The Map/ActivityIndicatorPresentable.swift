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
        
        let activityIndicatorVC = UIStoryboard(name: Constants.StoryBoardID.main, bundle: nil).instantiateViewController(withIdentifier: Constants.StoryBoardID.activityIndicatorVC) as! ActivityIndicatorViewController
        return activityIndicatorVC
    }
    
    internal func presentActivityIndicator(_ activityIndicator: ActivityIndicatorViewController, transitioningDelegate delegate: OverlayTransitioningDelegate, completion: (() -> Void)?) {
        
        activityIndicator.transitioningDelegate = delegate
        activityIndicator.modalPresentationStyle = .custom
        
        delegate.configureTransitionWithContentSize(
            CGSize(width: 80, height: 80),
            options: [
                .inFromPosition : Position.center,
                .durationIn: 0.3,
                .alphaIn: true,
                .scaleIn: true,
                .outToPosition: Position.center,
                .durationOut: 0.3,
                .alphaOut: true,
                .scaleOut: true,
                .dimmingBGColor: Theme.presentationDimBGColor
            ])
        
        activityIndicatorIsPresented = true
        present(activityIndicator, animated: true, completion: completion)
    }
    
    internal func dismissActivityIndicator(completion: (() -> Void)?) {
        self.activityIndicatorIsPresented = false
        dismiss(animated: true, completion: {
            self.activityIndicatorViewController = nil
            completion?()
        })
    }
}
