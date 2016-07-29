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
    
    private var mapContainterView: StudentLocationMapContainerView!
    
    private var sessionLogoutController = UserSessionLogoutController()
    
    internal var activityIndicatorViewController: ActivityIndicatorViewController?
    private var activityIndicatorTransitioningDelegate: OverlayTransitioningDelegate?
    
    /// InformationPostingPresentable
    internal var informationPostingNavController: InformationPostingNavigationController?
    
    
//    deinit { magic("\(self.description) is being deinitialized   <----------------") }
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapContainterView = view as! StudentLocationMapContainerView
        
        configureNavigationController()

        let refreshClosure = { [weak self] in
            self!.getStudentInfoArray()
        }
        
        activityIndicatorTransitioningDelegate = OverlayTransitioningDelegate()
        
        let presentActivityIndicator = { [unowned self] (completion: (() -> Void)?) in
            self.presentActivityIndicator(
                self.getActivityIndicatorViewController(),
                transitioningDelegate: self.activityIndicatorTransitioningDelegate!,
                completion: completion)
        }
        
        let presentErrorAlert = getAlertPresentation()
        
        let logoutSuccessClosure = { [unowned self] in
            self.dismissActivityIndicator(completion: {
                self.dismissViewControllerAnimated(true, completion: nil)
            })
        }
        
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
