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
    
//    private var emptyDataSetVC: EmptyDataSetViewController?
    
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
        
        addButton = UIBarButtonItem(
            barButtonSystemItem: .Add,
            target: self,
            action: #selector(addButtonTapped))
        rightItemArray.append(addButton)
        
        navigationBar.topItem?.rightBarButtonItems = rightItemArray
        
        logoutButton = UIBarButtonItem(
        title: LocalizedStrings.NavigationControllerButtons.logout,
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
