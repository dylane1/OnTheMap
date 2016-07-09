//
//  StudentLocationMapContainerViewController.swift
//  On The Map
//
//  Created by Dylan Edwards on 4/22/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

final class StudentLocationMapContainerViewController: UIViewController, MapAndTableNavigationProtocol, StudentInformationGettable, InformationPostingPresentable, SafariViewControllerPresentable, AlertPresentable, ActivityIndicatorPresentable {
    
    private let studentInformationProvider = StudentInformationProvider.sharedInstance
    
    private var tabBar: TabBarController!
    private var mapContainterView: StudentLocationMapContainerView!
    
    private var sessionLogoutController = UserSessionLogoutController()
    
    /// InformationPostingPresentable
    internal var informationPostingNavController: InformationPostingNavigationController?
    
    /// ActivityIndicatorPresentable
    internal var activityIndicatorViewController: PrimaryActivityIndicatorViewController?
    
    //MARK: - View Lifecycle
    deinit { magic("being deinitialized   <----------------") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = LocalizedStrings.ViewControllerTitles.onTheMap
        
        let navController = navigationController! as! MapAndTableNavigationController
        navController.setNavigationBarAttributes(isAppTitle: true)
        
        tabBar = tabBarController as! TabBarController

        let refreshClosure = { [weak self] in
            self!.getStudentInfoArray()
        }
        
        /// MapAndTableNavigationProtocol
        configureNavigationItems(withRefreshClosure: refreshClosure, sessionLogoutController: sessionLogoutController, successfulLogoutCompletion: tabBar.successfulLogoutCompletion!)
    }

    override func viewWillAppear(animated: Bool) {
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
        performFetchWithCompletion(completion)
    }
    
    private func openLink(withURLString link: String) {
        /// SafariViewControllerPresentable
        openLinkInSafari(withURLString: link)
    }
}




