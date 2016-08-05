//
//  MapAndTableViewControllerProtocol.swift
//  On The Map
//
//  Created by Dylan Edwards on 8/5/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

protocol MapAndTableViewControllerProtocol: class {
    var presentActivityIndicator: (((() -> Void)?) -> Void)! { get set }
    var logoutSuccessClosure: (() -> Void)! { get set }
    var sessionLogoutController: UserSessionLogoutController! { get set }
}

extension MapAndTableViewControllerProtocol where Self: UIViewController, Self: ActivityIndicatorPresentable, Self: AlertPresentable {
    internal func getActivityIndicatorPresentationClosure() -> ((() -> Void)?) -> Void {
        let presentActivityIndicatorClosure = { [weak self] (completion: (() -> Void)?) in
            self!.activityIndicatorViewController = self!.getActivityIndicatorViewController()
            self!.overlayTransitioningDelegate    = OverlayTransitioningDelegate()
            self!.presentActivityIndicator(
                self!.activityIndicatorViewController!,
                transitioningDelegate: self!.overlayTransitioningDelegate!,
                completion: completion)
        }
        return presentActivityIndicatorClosure
    }
    
    internal func getLogoutSuccessClosure(withCompletion completion: (() -> Void)?) -> () -> Void {
        let logoutSuccess = { [weak self] in
            self!.dismissActivityIndicator(completion: {
                self!.dismissViewControllerAnimated(true, completion: {
                    completion?()
                })
            })
        }
        return logoutSuccess
    }
    
    internal func configureSessionLogout() {
        sessionLogoutController = UserSessionLogoutController()
        
        sessionLogoutController!.configure(
            withActivityIndicatorPresentation: presentActivityIndicator,
            logoutSuccessClosure: logoutSuccessClosure,
            alertPresentationClosure: getAlertPresentation())
    }
}
