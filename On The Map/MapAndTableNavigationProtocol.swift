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
    
    internal func configureNavigationItems(withFacebookLoginStatus isFB: Bool, refreshClosure refresh: () -> Void) {
        
        let addButtonClosure = { [weak self] in
            self!.informationPostingNavController = self!.getInfoPostingNavigationController()
            self!.presentViewController(self!.informationPostingNavController!, animated: true, completion: nil)
        }
        
        let refreshButtonClosure = {
            refresh()
        }
        
        var logoutButtonClosure: BarButtonClosure?
        if isFB {
            logoutButtonClosure = { [weak self] in
                magic("Logout of FB")
            }
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
