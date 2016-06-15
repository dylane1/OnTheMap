//
//  LocationMapViewController.swift
//  On The Map
//
//  Created by Dylan Edwards on 4/22/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

final class LocationMapViewController: UIViewController, MapAndTableNavigationProtocol, StudentInformationGettable, InformationPostingPresentable {
    
    /// StudentInformationGettable
    internal var studentInformationArray: [StudentInformation]? {
        didSet {
            magic("infos!!! \(studentInformationArray)")
        }
    }
    
    private var tabBar: TabBarController!
    
    /// InformationPostingPresentable
    internal var informationPostingNavController: NavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /** Set special font for the app title */
        let navController = navigationController! as! NavigationController
        navController.setNavigationBarAttributes(isAppTitle: true)
        
        title = LocalizedStrings.ViewControllerTitles.onTheMap
        
        tabBar = tabBarController as! TabBarController
        
        /// MapAndTableNavigationProtocol
        configureNavigationItems(withFacebookLoginStatus: tabBar.appModel.isLoggedInViaFacebook)
        
        getStudentInfoArray()
    }

    //MARK: - 
    
    private func getStudentInfoArray() {
        let completion = { (studentInfo: [StudentInformation]) in
            self.studentInformationArray = studentInfo
        }
        
        /// StudentInformationGettable
        getStudentInformation(withCompletion: completion)
    }

}




