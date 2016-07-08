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
    
    //MARK: - View Lifecycle
    deinit { magic("being deinitialized   <----------------") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = LocalizedStrings.ViewControllerTitles.onTheMap
        
        let navController = navigationController! as! MapAndTableNavigationController
        navController.setNavigationBarAttributes(isAppTitle: true)
        
        tabBar = tabBarController as! TabBarController
        
        tableView.delegate = self
        
        let refreshClosure = { [weak self] in
            self!.getStudentInfoArray()
        }
        
//        let logoutInitiatedClosure = { [weak self] in
//            let activityIndicatorVC = self!.getActivityIndicatorViewController()
//            self!.presentViewController(activityIndicatorVC, animated: false, completion: nil)
//        }
        
        /// MapAndTableNavigationProtocol
        configureNavigationItems(withRefreshClosure: refreshClosure, sessionLogoutController: sessionLogoutController,/* logoutInitiatedClosure: logoutInitiatedClosure,*/ successfulLogoutCompletion: tabBar.successfulLogoutCompletion!)
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

        let testImg = UIImage()
        let model = StudentLocationCellModel(image: testImg, studentInformation: studentInformationProvider.studentInformationArray![indexPath.row])
        
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
