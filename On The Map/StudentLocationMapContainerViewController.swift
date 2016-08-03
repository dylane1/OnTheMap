//
//  StudentLocationMapContainerViewController.swift
//  On The Map
//
//  Created by Dylan Edwards on 4/22/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

final class StudentLocationMapContainerViewController: UIViewController, MapAndTableNavigationProtocol, StudentInformationGettable, InformationPostingPresentable, SafariViewControllerPresentable, AlertPresentable, ActivityIndicatorPresentable {
    
    private var mapContainterView: StudentLocationMapContainerView?
    
    /// InformationPostingPresentable
    internal var informationPostingNavController: InformationPostingNavigationController?
    
    /// ActivityIndicatorPresentable
    internal var activityIndicatorViewController: ActivityIndicatorViewController?
    internal var overlayTransitioningDelegate: OverlayTransitioningDelegate?
    internal var activityIndicatorIsPresented = false
    
    private var sessionLogoutController: UserSessionLogoutController!
    
//    deinit { magic("\(self.description) is being deinitialized   <----------------") }
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapContainterView = view as? StudentLocationMapContainerView
        
        configureNavigationController()
        
        let refreshClosure = { [weak self] in
            self!.getStudentInfoArray()
        }
        
        let presentActivityIndicator = { [weak self] (completion: (() -> Void)?) in
            self!.activityIndicatorViewController = self!.getActivityIndicatorViewController()
            self!.overlayTransitioningDelegate    = OverlayTransitioningDelegate()
            self!.presentActivityIndicator(
                self!.activityIndicatorViewController!,
                transitioningDelegate: self!.overlayTransitioningDelegate!,
                completion: completion)
        }
        
        let presentErrorAlert = getAlertPresentation()
        
        let logoutSuccessClosure = { [weak self] in
            self!.dismissActivityIndicator(completion: {
                self!.dismissViewControllerAnimated(true, completion: {

//                    /// Prevent memory leak
                    self!.mapContainterView          = nil
//                    self.sessionLogoutController    = nil
                })
            })
        }
        
        sessionLogoutController = UserSessionLogoutController()
        
        sessionLogoutController!.configure(
            withActivityIndicatorPresentation: presentActivityIndicator,
            logoutSuccessClosure: logoutSuccessClosure,
            alertPresentationClosure: presentErrorAlert)
        
        /// MapAndTableNavigationProtocol
        configureNavigationItems(
            withRefreshClosure: refreshClosure,
            sessionLogoutController: sessionLogoutController)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        getStudentInfoArray()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        mapContainterView!.clearAnnotations()
//        mapContainterView = nil
    }
    
    //MARK: - Configuration
    
    private func configureViewWithStudentArray(array: [StudentInformation]) {
        
        let openLinkClosure = { [weak self] (urlString: String) in
            self!.openLink(withURLString: urlString)
        }
        
        mapContainterView!.configure(withStudentInformationArray: array, openLinkClosure: openLinkClosure)
    }
    
    //MARK: - 
    
    private func getStudentInfoArray() {
        let completion = { [weak self] (studentInfoArray: [StudentInformation]) in
            self!.configureViewWithStudentArray(studentInfoArray)
        }
        
        /// StudentInformationGettable
        performFetchWithCompletion(completion)
    }
    
    private func openLink(withURLString link: String) {
        /// SafariViewControllerPresentable
        openLinkInSafari(withURLString: link)
    }
}
