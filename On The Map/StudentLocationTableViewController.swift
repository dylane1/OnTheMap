//
//  StudentLocationTableViewController.swift
//  On The Map
//
//  Created by Dylan Edwards on 4/22/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

final class StudentLocationTableViewController: UITableViewController, MapAndTableViewControllerProtocol, MapAndTableNavigationProtocol, StudentInformationGettable, InformationPostingPresentable, SafariViewControllerPresentable, AlertPresentable, ActivityIndicatorPresentable {
    
    fileprivate lazy var studentInfoProvider = StudentInformationProvider.sharedInstance
    
    fileprivate var presentMapViewController: ((_ locationName: String, _ latitude: Double, _ longitude: Double) -> Void)!
    fileprivate var mapOverlayTransitioningDelegate: OverlayTransitioningDelegate?
    
    fileprivate var mapViewController: MapContainerViewController?
    
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
        
        configureNavigationController()

        tableView.delegate = self
        tableView.backgroundColor = Theme.tableViewBGColor
        
        let refreshClosure = { [weak self] in
            self!.getStudentInfo()
        }
        
        presentActivityIndicator = getActivityIndicatorPresentationClosure()
        
        logoutSuccessClosure = getLogoutSuccessClosure(withCompletion: nil)
        
        configureSessionLogout()
        
        /// MapAndTableNavigationProtocol
        configureNavigationItems(
            withRefreshClosure: refreshClosure,
            sessionLogoutController: sessionLogoutController)
        
        presentMapViewController = { [weak self] (locationName: String, latitude: Double, longitude: Double) in
            
            self!.openMapViewController(withLocationName: locationName, latitude: latitude, longitude: longitude)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getStudentInfo()
    }
    
    //MARK: -
    
    fileprivate func getStudentInfo() {
        let completion = { [weak self] in
            self!.tableView.reloadData()
        }
        
        /// StudentInformationGettable
        performFetchWithCompletion(completion)
    }
    
    fileprivate func openMapViewController(withLocationName name: String, latitude: Double, longitude: Double) {
        
        mapViewController = UIStoryboard(name: Constants.StoryBoardID.main, bundle: nil).instantiateViewController(withIdentifier: Constants.StoryBoardID.mapPresentationVC) as? MapContainerViewController
        
        mapViewController!.configure(withLocationName: name, latitude: latitude, longitude: longitude)
        
        let width = self.view.frame.width - 40
        let height = width
        let mapVCPreferredContentSize = CGSize(width: width, height: height)
        
        let dismissalCompletion = { [weak self] in
            self!.mapOverlayTransitioningDelegate    = nil
            self!.mapViewController                  = nil
        }
        
        mapOverlayTransitioningDelegate = OverlayTransitioningDelegate()
        
        mapOverlayTransitioningDelegate!.configureTransitionWithContentSize(mapVCPreferredContentSize, options: [
            .dimmingBGColor : Theme.presentationDimBGColor,
            .inFromPosition : Position.center,
            .outToPosition : Position.center,
            .alphaIn : true,
            .alphaOut : true,
            .tapToDismiss:  true,
            .scaleIn : true,
            .scaleOut : true
            ], dismissalCompletion: dismissalCompletion)
        
        mapViewController!.transitioningDelegate = mapOverlayTransitioningDelegate!
        mapViewController!.modalPresentationStyle = .custom
        
        present(mapViewController!, animated: true, completion: nil)
    }
    
}

//MARK: - Table View Data Source
extension StudentLocationTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (studentInfoProvider.studentInformationArray == nil) ? 0 : studentInfoProvider.studentInformationArray!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> StudentLocationTableViewCell {

        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as StudentLocationTableViewCell

        let model = StudentLocationCellModel(studentInformation: studentInfoProvider.studentInformationArray![indexPath.row])
        
        cell.configure(withDataSource: model, presentMapViewController: presentMapViewController)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}


//MARK: - Table View Delegate
extension StudentLocationTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        /// SafariViewControllerPresentable
        openLinkInSafari(withURLString: studentInfoProvider.studentInformationArray![indexPath.row].mediaURL)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 78.0
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        /// Allows the bottom cell to be fully visible when scrolled to end of list
        return 2.0
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView              = UIView()
        footerView.frame            = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 2.0)
        footerView.backgroundColor  = UIColor.clear
        return footerView
    }
}
