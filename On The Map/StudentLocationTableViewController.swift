//
//  StudentLocationTableViewController.swift
//  On The Map
//
//  Created by Dylan Edwards on 4/22/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

final class StudentLocationTableViewController: UITableViewController, MapAndTableNavigationProtocol, StudentInformationGettable, InformationPostingPresentable, SafariViewControllerPresentable, AlertPresentable, ActivityIndicatorPresentable {
    
    private let studentInformationProvider = StudentInformationProvider.sharedInstance
    
    private var tabBar: TabBarController!
    
    /// InformationPostingPresentable
    internal var informationPostingNavController: InformationPostingNavigationController?
    
    /// ActivityIndicatorPresentable
    internal var activityIndicatorViewController: PrimaryActivityIndicatorViewController?
    
    private var sessionLogoutController = UserSessionLogoutController()
    
    private let iconProvider = IconProvider()
    private var locationMarker: UIImage!
    
    //MARK: - View Lifecycle
    deinit { magic("being deinitialized   <----------------") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationController()
        
        navigationItem.title    = LocalizedStrings.ViewControllerTitles.onTheMap
        
        let navController = navigationController! as! MapAndTableNavigationController
        navController.setNavigationBarAttributes(isAppTitle: true)

        tableView.delegate = self
        tableView.backgroundColor = Theme03.tableViewBGColor
        
        let refreshClosure = { [weak self] in
            self!.getStudentInfoArray()
        }
        
        let presentActivityIndicator = getActivityIndicatorPresentation()
        let presentErrorAlert = getAlertPresentation()
        
        let logoutSuccessClosure = getSuccessfulLogoutClosure()
        
        sessionLogoutController.configure(
            withActivityIndicatorPresentation: presentActivityIndicator,
            logoutSuccessClosure: logoutSuccessClosure,
            alertPresentationClosure: presentErrorAlert)
        
        /// MapAndTableNavigationProtocol
        configureNavigationItems(
            withRefreshClosure: refreshClosure,
            sessionLogoutController: sessionLogoutController)
        
        locationMarker = iconProvider.imageOfDrawnIcon(.LocationMarker, size: CGSize(width: 40, height: 43), fillColor: Theme03.locationMarker)
    }
    
    override func viewWillAppear(animated: Bool) {
        getStudentInfoArray()
    }
    
    //MARK: -
    
    private func getStudentInfoArray() {
        let completion = { [weak self] in
            self!.tableView.reloadData()
        }
        
        /// StudentInformationGettable
        performFetchWithCompletion(completion)
    }
    /*
    private func openNewIntervalSetupViewController(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)//Close any popovers
        
        /* User figured it out, kill the Help Prompt countdown */
        if helpPromptCountdownEngine != nil { killCountdownEngine() }
        
        newIntervalSetupVC = UIStoryboard(name: StoryBoardIDs.sb_Main, bundle: nil).instantiateViewControllerWithIdentifier(StoryBoardIDs.sb_newIntervalSetupVC) as? NewIntervalSetupViewController
        
        //        newIntervalSetupVC!.preferredContentSize = CGSizeMake(310, 310)
        
        newIntervalSetupVC!.titleTextFieldPlaceholder = LocalizedStrings.Common.anInterval //"\(LocalizedStrings.Common.interval) \(intervalArray.count + 1)"
        
        newIntervalSetupVC!.didFinish = { [weak self] (controller, newObjectArray: [AnyObject]) in
            self!.addNewTimerIntervals(newObjectArray as! [TimerInterval])
            self!.toggleWelcomeText()
            
            self!.dismissViewControllerAnimated(true, completion: {
                self!.newIntervalSetupVC = nil
            })
            
        }
        
        newIntervalSetupVC!.didCancel = { [weak self] controller in
            self!.dismissViewControllerAnimated(true, completion: {
                self!.newIntervalSetupVC = nil
            })
        }
        
        //        prepareOverlayVC(newIntervalSetupVC!)
        overlayTransitioningDelegate = OverlayTransitioningDelegate(withPreferredContentSize: CGSizeMake(310, 310), cornerRadius: 12.0, dimmingBGColor: UIColor(white: 0.0, alpha: 0.5), doFadeInAlpha: true)
        
        newIntervalSetupVC!.transitioningDelegate = overlayTransitioningDelegate
        newIntervalSetupVC!.modalPresentationStyle = .Custom
        
        presentViewController(newIntervalSetupVC!, animated: true, completion: nil)
    }
    */
}

//MARK: - Table View Data Source
extension StudentLocationTableViewController {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (studentInformationProvider.studentInformationArray == nil) ? 0 : studentInformationProvider.studentInformationArray!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> StudentLocationTableViewCell {

        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as StudentLocationTableViewCell

        let model = StudentLocationCellModel(image: locationMarker, studentInformation: studentInformationProvider.studentInformationArray![indexPath.row])
        
        cell.configure(withDataSource: model)
        
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
        openLinkInSafari(withURLString: studentInformationProvider.studentInformationArray![indexPath.row].mediaURL)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 59.0
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
