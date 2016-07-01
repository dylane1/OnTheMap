//
//  StudentLocationMapContainerViewController.swift
//  On The Map
//
//  Created by Dylan Edwards on 4/22/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

final class StudentLocationMapContainerViewController: UIViewController, MapAndTableNavigationProtocol, StudentInformationGettable, InformationPostingPresentable, SafariViewControllerPresentable, AlertPresentable {
    
    private let studentInformationProvider = StudentInformationProvider.sharedInstance
    
    private var tabBar: TabBarController!
    private var mapContainterView: StudentLocationMapContainerView!
    
    /// InformationPostingPresentable
    internal var informationPostingNavController: NavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navController = navigationController! as! NavigationController
        navController.setNavigationBarAttributes(isAppTitle: true)
        
        title = LocalizedStrings.ViewControllerTitles.onTheMap
        
        tabBar = tabBarController as! TabBarController

        let refreshClosure = { [weak self] in
            self!.mapContainterView.clearAnnotations()
            self!.getStudentInfoArray()
        }
        
        /// MapAndTableNavigationProtocol
        configureNavigationItems(withRefreshClosure: refreshClosure)
        
        getStudentInfoArray()
    }

    //MARK: - Configuration
    private func configureView() {
        mapContainterView = view as! StudentLocationMapContainerView
        
        let openLinkClosure = { [weak self] (urlString: String) in
            self!.openLink(withURLString: urlString)
        }
        mapContainterView.configure(withStudentInformationArray: studentInformationProvider.studentInformationArray!, openLinkClosure: openLinkClosure)
    }
    
    //MARK: - 
    
    private func getStudentInfoArray() {
        let completion = { [weak self] in
            self!.configureView()
        }
        
        /// StudentInformationGettable
        getStudentInformation(withCompletion: completion)
    }
    
    private func openLink(withURLString link: String) {
        /// SafariViewControllerPresentable
        openLinkInSafari(withURLString: link)
    }
}




