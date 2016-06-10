//
//  LocationTableViewController.swift
//  On The Map
//
//  Created by Dylan Edwards on 4/22/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

final class LocationTableViewController: UITableViewController, MapAndTableNavigationProtocol, InformationPostingPresentable {
    
    internal var informationPostingNavController: NavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /** Set special font for the app title */
        let navController = navigationController! as! NavigationController
        navController.setNavigationBarAttributes(isAppTitle: true)
        
        title = LocalizedStrings.ViewControllerTitles.onTheMap
        
        let tabBar = tabBarController as! TabBarController
        configureNavigationItems(withFacebookLoginStatus: tabBar.appModel.isLoggedInViaFacebook)
    }
}

