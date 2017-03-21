//
//  MapAndTableNavigationController.swift
//  On The Map
//
//  Created by Dylan Edwards on 6/8/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

final class MapAndTableNavigationController: NavigationController {
    
    fileprivate var addClosure: BarButtonClosure?
    fileprivate var addButton: UIBarButtonItem!
    
    fileprivate var refreshClosure: BarButtonClosure?
    fileprivate var refreshButton: UIBarButtonItem!
    
    fileprivate var logoutClosure: BarButtonClosure?
    fileprivate var logoutButton: UIBarButtonItem?
    
    //MARK: - Configuration
    
    internal func configure(withAddClosure add: @escaping BarButtonClosure, refreshClosure refresh: @escaping BarButtonClosure, logoutClosure logout: @escaping BarButtonClosure) {
        addClosure      = add
        refreshClosure  = refresh
        logoutClosure   = logout
        
        configureNavigationItems()
    }
    
    fileprivate func configureNavigationItems() {
        var rightItemArray  = [UIBarButtonItem]()
        
        refreshButton = UIBarButtonItem(
            barButtonSystemItem: .refresh,
            target: self,
            action: #selector(refreshButtonTapped))
        rightItemArray.append(refreshButton)
        
        let pinButton   = UIButton(type: .system)
        pinButton.frame    = CGRect(x: 0, y: 0, width: 44, height: 44)
        pinButton.addTarget(self, action: #selector(addButtonTapped), for: UIControlEvents.touchUpInside)
        
        let pinImage = IconProvider.imageOfDrawnIcon(.Pin, size: CGSize(width: 32, height: 32), fillColor: Theme.tabBarItemUnselected)
        
        pinButton.setImage(pinImage, for: UIControlState())
        
        let addButton = UIBarButtonItem(customView: pinButton)
        
        rightItemArray.append(addButton)
        
        navigationBar.topItem?.rightBarButtonItems = rightItemArray
        
        logoutButton = UIBarButtonItem(
            title: LocalizedStrings.BarButtonTitles.logout,
            style: .plain,
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
