//
//  StudentLocationTableViewController.swift
//  On The Map
//
//  Created by Dylan Edwards on 4/22/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

final class StudentLocationTableViewController: UITableViewController, MapAndTableNavigationProtocol, StudentInformationGettable, InformationPostingPresentable, SafariViewControllerPresentable, AlertPresentable, ActivityIndicatorPresentable {
    
    private var studentInformationArray: [StudentInformation]?
    
    private var presentMapViewController: ((locationName: String, latitude: Double, longitude: Double) -> Void)!
    private var mapOverlayTransitioningDelegate: OverlayTransitioningDelegate?
    
    private var mapViewController: MapContainerViewController?
    
    /// InformationPostingPresentable
    internal var informationPostingNavController: InformationPostingNavigationController?
    
    /// ActivityIndicatorPresentable
    internal var activityIndicatorViewController: ActivityIndicatorViewController?
    internal var overlayTransitioningDelegate: OverlayTransitioningDelegate?
    internal var activityIndicatorIsPresented = false
    
    private var sessionLogoutController: UserSessionLogoutController!
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationController()
        
        navigationItem.title    = LocalizedStrings.ViewControllerTitles.onTheMap
        
        let navController = navigationController! as! MapAndTableNavigationController
        navController.setNavigationBarAttributes(isAppTitle: true)

        tableView.delegate = self
        tableView.backgroundColor = Theme.tableViewBGColor
        
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
                    self!.sessionLogoutController        = nil
                    self!.overlayTransitioningDelegate   = nil
                    self!.studentInformationArray        = nil
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
        
        presentMapViewController = { [weak self] (locationName: String, latitude: Double, longitude: Double) in
            
            self!.openMapViewController(withLocationName: locationName, latitude: latitude, longitude: longitude)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        getStudentInfoArray()
    }
    
    //MARK: -
    
    private func getStudentInfoArray() {
        let completion = { [weak self] (studentInfoArray: [StudentInformation]) in
            self!.studentInformationArray = studentInfoArray
            self!.tableView.reloadData()
        }
        
        /// StudentInformationGettable
        performFetchWithCompletion(completion)
    }
    
    private func openMapViewController(withLocationName name: String, latitude: Double, longitude: Double) {
        
        mapViewController = UIStoryboard(name: Constants.StoryBoardID.main, bundle: nil).instantiateViewControllerWithIdentifier(Constants.StoryBoardID.mapPresentationVC) as? MapContainerViewController
        
        mapViewController!.configure(withLocationName: name, latitude: latitude, longitude: longitude)
        
        let width = self.view.frame.width - 40
        let height = width
        let mapVCPreferredContentSize = CGSizeMake(width, height)
        
        let dismissalCompletion = { [weak self] in
            self!.mapOverlayTransitioningDelegate    = nil
            self!.mapViewController                  = nil
        }
        
        mapOverlayTransitioningDelegate = OverlayTransitioningDelegate()
        
        mapOverlayTransitioningDelegate!.configureTransitionWithContentSize(mapVCPreferredContentSize, dismissalCompletion: dismissalCompletion, options: [
            .DimmingBGColor : Theme.presentationDimBGColor,
            .InFromPosition : Position.Center,
            .OutToPosition : Position.Center,
            .AlphaIn : true,
            .AlphaOut : true,
            .TapToDismiss:  true,
            .ScaleIn : true,
            .ScaleOut : true
            ])
        
        mapViewController!.transitioningDelegate = mapOverlayTransitioningDelegate!
        mapViewController!.modalPresentationStyle = .Custom
        
        presentViewController(mapViewController!, animated: true, completion: nil)
    }
    
}

//MARK: - Table View Data Source
extension StudentLocationTableViewController {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (studentInformationArray == nil) ? 0 : studentInformationArray!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> StudentLocationTableViewCell {

        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as StudentLocationTableViewCell

        let model = StudentLocationCellModel(studentInformation: studentInformationArray![indexPath.row])
        
        cell.configure(withDataSource: model, presentMapViewController: presentMapViewController)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
}


//MARK: - Table View Delegate
extension StudentLocationTableViewController {
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        /// SafariViewControllerPresentable
        openLinkInSafari(withURLString: studentInformationArray![indexPath.row].mediaURL)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 78.0
    }
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        /// Allows the bottom cell to be fully visible when scrolled to end of list
        return 2.0
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView              = UIView()
        footerView.frame            = CGRectMake(0, 0, view.bounds.size.width, 2.0)
        footerView.backgroundColor  = UIColor.clearColor()
        return footerView
    }
}
