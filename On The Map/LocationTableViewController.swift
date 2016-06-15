//
//  LocationTableViewController.swift
//  On The Map
//
//  Created by Dylan Edwards on 4/22/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

final class LocationTableViewController: UITableViewController, MapAndTableNavigationProtocol, StudentInformationGettable,InformationPostingPresentable {
    
    /// StudentInformationGettable
    internal var studentInformationArray: [StudentInformation]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    private var tabBar: TabBarController!
    
    /// InformationPostingPresentable
    internal var informationPostingNavController: NavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /** Set special font for the app title */
        let navController = navigationController! as! NavigationController
        navController.setNavigationBarAttributes(isAppTitle: true)
        
        title = LocalizedStrings.ViewControllerTitles.onTheMap
        
        tabBar = tabBarController as! TabBarController
        
        tableView.delegate = self
        
        /// MapAndTableNavigationProtocol
        configureNavigationItems(withFacebookLoginStatus: tabBar.appModel.isLoggedInViaFacebook)
        
        getStudentInfoArray()
        
    }
    
    //MARK: -
    
    private func getStudentInfoArray() {
        let completion = { (studentInfo: [StudentInformation]) in
            self.studentInformationArray = studentInfo
        }
        
        /// StudentInformationGettable
        getStudentInformation(withCompletion: completion)
    }
}

//MARK: - Table View Data Source
//extension LocationTableViewController {
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return (studentInformationArray == nil) ? 0 : studentInformationArray!.count
//    }
//    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        
//        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.ReuseID.locationListTableCell, forIndexPath: indexPath) as! StudentLocationTableViewCell
//        
//        let model = SavedMemeCellModel(meme: storedMemesProvider.memeArray[indexPath.row])
//        
//        cell.configure(withDataSource: model)
//        
//        return cell
//    }
//    
//    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        return true
//    }
//    
//    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == .Delete {
//            storedMemesProvider.removeMemeFromStorage(atIndex: indexPath.row)
//            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//            
//            /** Reset the empty data set background, if needed */
//            configureTableView()
//        }
//    }
//}


//MARK: - Table View Delegate
//extension LocationTableViewController {
//    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        selectedIndexPath = indexPath
//        performSegueWithIdentifier(Constants.SegueID.memeDetail, sender: self)
//    }
//    
//    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        /** Allows the bottom cell to be fully visible when scrolled to end of list */
//        return 2
//    }
//    
//    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let footerView              = UIView()
//        footerView.frame            = CGRectMake(0, 0, view.bounds.size.width, 2.0)
//        footerView.backgroundColor  = UIColor.clearColor()
//        return footerView
//    }
//}
