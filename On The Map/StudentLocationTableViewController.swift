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
    private var overlayTransitioningDelegate: OverlayTransitioningDelegate?
    
    private var sessionLogoutController: UserSessionLogoutController?
    
//    private var locationMarker: UIImage!
    
    deinit { magic("\(self.description) is being deinitialized   <----------------") }
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationController()
        
        navigationItem.title    = LocalizedStrings.ViewControllerTitles.onTheMap
        
        let navController = navigationController! as! MapAndTableNavigationController
        navController.setNavigationBarAttributes(isAppTitle: true)

        tableView.delegate = self
        tableView.backgroundColor = Theme.tableViewBGColor
        
        let refreshClosure = {
            self.getStudentInfoArray()
        }
        
        let presentActivityIndicator = { (completion: (() -> Void)?) in
            self.overlayTransitioningDelegate = OverlayTransitioningDelegate()
            self.presentActivityIndicator(
                self.getActivityIndicatorViewController(),
                transitioningDelegate: self.overlayTransitioningDelegate!,
                completion: completion)
        }
        
        let presentErrorAlert = getAlertPresentation()
        
        let logoutSuccessClosure = {
            self.dismissActivityIndicator(completion: {
                self.dismissViewControllerAnimated(true, completion: {
                    self.sessionLogoutController        = nil
                    self.overlayTransitioningDelegate   = nil
                    self.studentInformationArray        = nil
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
            sessionLogoutController: sessionLogoutController!)
        
//        locationMarker = IconProvider.imageOfDrawnIcon(.LocationMarker, size: CGSize(width: 40, height: 43), fillColor: Theme.locationMarker)
        
        presentMapViewController = { [weak self] (locationName: String, latitude: Double, longitude: Double) in
            
            self!.openMapViewController(withLocationName: locationName, latitude: latitude, longitude: longitude)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
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
        
        let dismissalCompletion = {
            self.mapOverlayTransitioningDelegate    = nil
            self.mapViewController                  = nil
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
