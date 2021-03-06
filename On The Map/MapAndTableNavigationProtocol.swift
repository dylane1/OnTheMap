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
    
    internal func configureNavigationController() {
        navigationItem.title    = LocalizedStrings.ViewControllerTitles.onTheMap
        
        let navController = navigationController! as! MapAndTableNavigationController
        navController.setNavigationBarAttributes(isAppTitle: true)
    }
    
    internal func configureNavigationItems(withRefreshClosure refresh: @escaping BarButtonClosure, sessionLogoutController logoutController: UserSessionLogoutController) {
        
        let addButtonClosure = { [weak self] in
            self!.informationPostingNavController = self!.getInfoPostingNavigationController()
            self!.present(self!.informationPostingNavController!, animated: true, completion: nil)
        }
        
        let refreshButtonClosure = {
            refresh()
        }
        
        let logoutButtonClosure = {
            logoutController.logout()
        }
        
        mapAndTableNavController.configure(withAddClosure: addButtonClosure, refreshClosure: refreshButtonClosure, logoutClosure: logoutButtonClosure)
    }
}
