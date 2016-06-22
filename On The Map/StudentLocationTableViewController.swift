//
//  StudentLocationTableViewController.swift
//  On The Map
//
//  Created by Dylan Edwards on 4/22/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

final class StudentLocationTableViewController: UITableViewController, MapAndTableNavigationProtocol, StudentInformationGettable, InformationPostingPresentable, SafariViewControllerPresentable {
    
    private let infoProvider = StudentInformationProvider.sharedInstance
    
    private var tabBar: TabBarController!
    
    /// InformationPostingPresentable
    internal var informationPostingNavController: NavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Set special font for the app title
        let navController = navigationController! as! NavigationController
        navController.setNavigationBarAttributes(isAppTitle: true)
        
        title = LocalizedStrings.ViewControllerTitles.onTheMap
        
        tabBar = tabBarController as! TabBarController
        
        tableView.delegate = self
        
        let refreshClosure = {
            self.getStudentInfoArray()
        }
        
        /// MapAndTableNavigationProtocol
        configureNavigationItems(withRefreshClosure: refreshClosure)
        
        getStudentInfoArray()
    }
    
    //MARK: -
    
    private func getStudentInfoArray() {
        let completion = {
            self.tableView.reloadData()
        }
        
        /// StudentInformationGettable
        getStudentInformation(withCompletion: completion)
    }
}

//MARK: - Table View Data Source
extension StudentLocationTableViewController {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (infoProvider.studentInformationArray == nil) ? 0 : infoProvider.studentInformationArray!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> StudentLocationTableViewCell {

        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as StudentLocationTableViewCell

        let testImg = UIImage()
        let model = StudentLocationCellModel(image: testImg, studentInformation: infoProvider.studentInformationArray![indexPath.row])
        
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
        openLinkInSafari(withURLString: infoProvider.studentInformationArray![indexPath.row].mediaURL)
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        /// Allows the bottom cell to be fully visible when scrolled to end of list
        return 2
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView              = UIView()
        footerView.frame            = CGRectMake(0, 0, view.bounds.size.width, 2.0)
        footerView.backgroundColor  = UIColor.clearColor()
        return footerView
    }
}
