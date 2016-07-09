//
//  MapAndTableNavigationProtocol.swift
//  On The Map
//
//  Created by Dylan Edwards on 6/9/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

protocol MapAndTableNavigationProtocol {
    var mapAndTableNavController: MapAndTableNavigationController { get }
}

extension MapAndTableNavigationProtocol where Self: UIViewController, Self: InformationPostingPresentable, Self: AlertPresentable, Self: ActivityIndicatorPresentable {
    
    var mapAndTableNavController: MapAndTableNavigationController {
        return navigationController as! MapAndTableNavigationController
    }
    
    internal func configureNavigationItems(withRefreshClosure refresh: BarButtonClosure, sessionLogoutController logoutController: UserSessionLogoutController, successfulLogoutCompletion logoutCompletion: () -> Void) {
        
        let addButtonClosure = { [weak self] in
            self!.informationPostingNavController = self!.getInfoPostingNavigationController()
            self!.presentViewController(self!.informationPostingNavController!, animated: true, completion: nil)
        }
        
        let refreshButtonClosure = {
            refresh()
        }
        
        let logoutButtonClosure = { [weak self] in
            /// Show Activity Indicator
            self!.activityIndicatorViewController = self!.getActivityIndicatorViewController()
            self!.presentActivityIndicator(self!.activityIndicatorViewController!, completion: nil)
            
            /// Completion for successful logout
            let completion = { [weak self] in
                self!.dismissActivityIndicator(self!.activityIndicatorViewController!, completion: {
                    /// Dismiss Tab Bar
                    self!.dismissViewControllerAnimated(true, completion: {
                        /// Set Tab Bar to nil
                        //FIXME: Get rid of this....
                        /**
                         Note: May not need this if I'm able to track down the
                         retain cycles preventing the tab bar from being deallocated
                         */
                        logoutCompletion()
                    })
                })
            }
            
            /// In event of error, dismiss activityIndicator and present alert
            let logoutFailedClosure = { [weak self] (parameters: AlertParameters) in
                let dismissalCompletion = { [weak self] in
                    self!.presentAlertWithParameters(parameters)
                }
                self!.dismissActivityIndicator(self!.activityIndicatorViewController!, completion: dismissalCompletion)
            }
            
            logoutController.logout(withCompletion: completion, errorHandler: logoutFailedClosure)
        }
        
        mapAndTableNavController.configure(withAddClosure: addButtonClosure, refreshClosure: refreshButtonClosure, logoutClosure: logoutButtonClosure)
    }
}
