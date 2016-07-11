//
//  MapAndTableNavigationController.swift
//  On The Map
//
//  Created by Dylan Edwards on 6/8/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

final class MapAndTableNavigationController: NavigationController {
    
    private var addClosure: BarButtonClosure?
    private var addButton: UIBarButtonItem!
    
    private var refreshClosure: BarButtonClosure?
    private var refreshButton: UIBarButtonItem!
    
    private var logoutClosure: BarButtonClosure?
    private var logoutButton: UIBarButtonItem?
    
    deinit { magic("being deinitialized   <----------------") }
    
    //MARK: - Configuration
    
    internal func configure(withAddClosure add: BarButtonClosure, refreshClosure refresh: BarButtonClosure, logoutClosure logout: BarButtonClosure) {
        addClosure      = add
        refreshClosure  = refresh
        logoutClosure   = logout
        
        configureNavigationItems()
    }
    
    private func configureNavigationItems() {
        var rightItemArray  = [UIBarButtonItem]()
        
        refreshButton = UIBarButtonItem(
            barButtonSystemItem: .Refresh,
            target: self,
            action: #selector(refreshButtonTapped))
        rightItemArray.append(refreshButton)
        
        let pinButton   = UIButton(type: .System)
        pinButton.frame    = CGRectMake(0, 0, 44, 44)
        pinButton.addTarget(self, action: #selector(addButtonTapped), forControlEvents: UIControlEvents.TouchUpInside)
        
        let pinImage = IconProvider.imageOfDrawnIcon(.Pin, size: .ThirtyTwo, fillColor: UIColor.blackColor())
        pinButton.setImage(pinImage, forState: .Normal)
        
        let addButton = UIBarButtonItem(customView: pinButton)
        
        rightItemArray.append(addButton)
        
        navigationBar.topItem?.rightBarButtonItems = rightItemArray
        
        logoutButton = UIBarButtonItem(
            title: LocalizedStrings.BarButtonTitles.logout,
            style: .Plain,
            target: self,
            action: #selector(logoutButtonTapped))
        
        navigationBar.topItem?.leftBarButtonItem = logoutButton!
    }
    
    //MARK: - Actions
    
    internal func addButtonTapped() {
        addClosure?()
    }
    
    internal func refreshButtonTapped() {
        refreshClosure?()
    }
    
    internal func logoutButtonTapped() {
        logoutClosure?()
    }
}
