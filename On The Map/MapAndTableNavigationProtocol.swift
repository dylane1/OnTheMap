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

extension MapAndTableNavigationProtocol where Self: UIViewController, Self: InformationPostingPresentable, Self: AlertPresentable {
    
    var mapAndTableNavController: MapAndTableNavigationController {
        return navigationController as! MapAndTableNavigationController
    }
    
    internal func configureNavigationItems(withRefreshClosure refresh: BarButtonClosure, sessionLogoutController logoutController: UserSessionLogoutController, logoutInitiatedClosure logoutInitiated: () -> Void, successfulLogoutCompletion logoutCompletion: () -> Void) {
        
        let addButtonClosure = { [weak self] in
            self!.informationPostingNavController = self!.getInfoPostingNavigationController()
            self!.presentViewController(self!.informationPostingNavController!, animated: true, completion: nil)
        }
        
        let refreshButtonClosure = {
            refresh()
        }
        
        let logoutButtonClosure = { [weak self] in
            /// Show Activity Indicator
            logoutInitiated()
            
            /// Completion for successful logout
            let completion = { [weak self] in
                /// Dismiss Activity Indicator
                self!.dismissViewControllerAnimated(false, completion: {
                    /// Dismiss Tab Bar
                    self!.dismissViewControllerAnimated(true, completion: {
                        /// Set Tab Bar to nil
                        logoutCompletion()
                    })
                })
            }
            logoutController.logout(withCompletion: completion, alertPresentationClosure: self!.getAlertPresentationClosure())
        }
        
        mapAndTableNavController.configure(withAddClosure: addButtonClosure, refreshClosure: refreshButtonClosure, logoutClosure: logoutButtonClosure)
    }
}
