//
//  MapAndTableNavigationProtocol.swift
//  On The Map
//
//  Created by Dylan Edwards on 6/9/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

protocol MapAndTableNavigationProtocol {
    var mapAndTableNavController: MapAndTableNavigationController { get }
}

extension MapAndTableNavigationProtocol where Self: UIViewController, Self: InformationPostingPresentable {
    
    var mapAndTableNavController: MapAndTableNavigationController {
        return navigationController as! MapAndTableNavigationController
    }
    
    internal func configureNavigationItems(withRefreshClosure refresh: BarButtonClosure) {
        
        let addButtonClosure = { [weak self] in
            self!.informationPostingNavController = self!.getInfoPostingNavigationController()
            self!.presentViewController(self!.informationPostingNavController!, animated: true, completion: nil)
        }
        
        let refreshButtonClosure = {
            refresh()
        }
        
        let logoutButtonClosure = { [weak self] in
            self!.dismissViewControllerAnimated(true, completion: nil)
        }
        
        mapAndTableNavController.configure(withAddClosure: addButtonClosure, refreshClosure: refreshButtonClosure, logoutClosure: logoutButtonClosure)
    }
    
//    internal func configureDetailViewController(forMeme meme: Meme, selectedIndex: Int, segue: UIStoryboardSegue, deletionClosure: ()->Void) {
//        
//        if segue.identifier == Constants.SegueID.memeDetail {
//            
//            let savedMemeVC = segue.destinationViewController as! SavedMemeDetailViewController
//            
//            savedMemeVC.configure(withSelectedIndex: selectedIndex, deletionClosure: deletionClosure)
//        }
//    }
}
