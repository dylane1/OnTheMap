//
//  StudentLocationMapContainerViewController.swift
//  On The Map
//
//  Created by Dylan Edwards on 4/22/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

final class StudentLocationMapContainerViewController: UIViewController, MapAndTableNavigationProtocol, StudentInformationGettable, InformationPostingPresentable, SafariViewControllerPresentable {
    
    private let infoProvider = StudentInformationProvider.sharedInstance
    
    private var tabBar: TabBarController!
    private var mapContainterView: StudentLocationMapContainerView!
    
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
            self.infoProvider.studentInformationArray = studentInfo
            self.configureView()
        }
        
        /// StudentInformationGettable
        getStudentInformation(withCompletion: completion)
    }

    private func configureView() {
        mapContainterView = view as! StudentLocationMapContainerView
        
        let openLinkClosure = { (urlString: String) in
            self.openLink(withURLString: urlString)
        }
        mapContainterView.configure(withStudentInfoArray: infoProvider.studentInformationArray!, openLinkClosure: openLinkClosure)
    }
    
    private func openLink(withURLString link: String) {
        /// SafariViewControllerPresentable
        openLinkInSafari(withURLString: link)
    }
}




