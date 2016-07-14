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
    
//    private var tabBar: TabBarController!
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
        
        mapContainterView = view as! StudentLocationMapContainerView
        mapContainterView.configureMapImage()
        
        configureNavigationController()

        let refreshClosure = { [weak self] in
            self!.getStudentInfoArray()
        }
        
        let presentActivityIndicator = {[unowned self] (completion: (() -> Void)?) in
            self.presentActivityIndicator(withPresentationCompletion: nil/*, dismissalCompletion: completion*/)
        }//getActivityIndicatorPresentation()
        let presentErrorAlert = getAlertPresentation()
        
        let logoutSuccessClosure = { [weak self] in
            self!.dismissViewControllerAnimated(true, completion: nil)
        }//getSuccessfulLogoutClosure()
        
        sessionLogoutController.configure(
            withActivityIndicatorPresentation: presentActivityIndicator,
            logoutSuccessClosure: logoutSuccessClosure,
            alertPresentationClosure: presentErrorAlert)
        
        /// MapAndTableNavigationProtocol
        configureNavigationItems(
            withRefreshClosure: refreshClosure,
            sessionLogoutController: sessionLogoutController)
    }

    override func viewWillAppear(animated: Bool) {
        getStudentInfoArray()
    }
    
    //MARK: - Configuration
    
    private func configureView() {
        
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




