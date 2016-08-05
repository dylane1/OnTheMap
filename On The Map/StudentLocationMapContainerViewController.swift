//
//  StudentLocationMapContainerViewController.swift
//  On The Map
//
//  Created by Dylan Edwards on 4/22/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

final class StudentLocationMapContainerViewController: UIViewController, MapAndTableViewControllerProtocol, MapAndTableNavigationProtocol, StudentInformationGettable, InformationPostingPresentable, SafariViewControllerPresentable, AlertPresentable, ActivityIndicatorPresentable {
    
    private var mapContainterView: StudentLocationMapContainerView?
    
    /// InformationPostingPresentable
    internal var informationPostingNavController: InformationPostingNavigationController?
    
    /// ActivityIndicatorPresentable
    internal var activityIndicatorViewController: ActivityIndicatorViewController?
    internal var overlayTransitioningDelegate: OverlayTransitioningDelegate?
    internal var activityIndicatorIsPresented = false
    
    /// MapAndTableViewControllerProtocol
    internal var presentActivityIndicator: (((() -> Void)?) -> Void)!
    internal var logoutSuccessClosure: (() -> Void)!
    internal var sessionLogoutController: UserSessionLogoutController!
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapContainterView = view as? StudentLocationMapContainerView
        
        configureNavigationController()
        
        let refreshClosure = { [weak self] in
            self!.getStudentInfo()
        }
        
        presentActivityIndicator = getActivityIndicatorPresentationClosure()
        
        let logoutSuccess = { [weak self] in
            self!.mapContainterView = nil
        }
        
        logoutSuccessClosure = getLogoutSuccessClosure(withCompletion: logoutSuccess)
        
        configureSessionLogout()
        
        /// MapAndTableNavigationProtocol
        configureNavigationItems(
            withRefreshClosure: refreshClosure,
            sessionLogoutController: sessionLogoutController)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        getStudentInfo()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        mapContainterView!.clearAnnotations()
    }
    
    //MARK: - Configuration
    
    private func configureView() {
        
        let openLinkClosure = { [weak self] (urlString: String) in
            self!.openLink(withURLString: urlString)
        }
        
        mapContainterView!.configure(withOpenLinkClosure: openLinkClosure)
    }
    
    //MARK: - 
    
    private func getStudentInfo() {
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
