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
    
    var sessionLogoutController: UserSessionLogoutController {
        return UserSessionLogoutController()
    }
    
    internal func configureNavigationItems(withRefreshClosure refresh: BarButtonClosure) {
        
        let addButtonClosure = { [weak self] in
            self!.informationPostingNavController = self!.getInfoPostingNavigationController()
            self!.presentViewController(self!.informationPostingNavController!, animated: true, completion: nil)
        }
        
        let refreshButtonClosure = {
            refresh()
        }
        
        let logoutButtonClosure = { [weak self] in
            let completion = { [weak self] in
                self!.dismissViewControllerAnimated(true, completion: nil)
            }
            self!.sessionLogoutController.logout(withCompletion: completion, alertPresentationClosure: self!.getAlertPresentationClosure())
        }
        
        mapAndTableNavController.configure(withAddClosure: addButtonClosure, refreshClosure: refreshButtonClosure, logoutClosure: logoutButtonClosure)
    }
}
