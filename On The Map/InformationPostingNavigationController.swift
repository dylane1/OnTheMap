//
//  InformationPostingNavigationController.swift
//  On The Map
//
//  Created by Dylan Edwards on 6/9/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

final class InformationPostingNavigationController: NavigationController {
    
    fileprivate var cancelClosure: BarButtonClosure?
    fileprivate var cancelButton: UIBarButtonItem?
    
    //MARK: - Configuration
    
    override func setNavigationBarAttributes(isAppTitle isTitle: Bool) {
        super.setNavigationBarAttributes(isAppTitle: isTitle)
    }
    
    internal func configure(withCancelClosure cancel: @escaping BarButtonClosure) {
        cancelClosure = cancel
        
        configureNavigationItems()
    }
    
    fileprivate func configureNavigationItems() {
        cancelButton = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelButtonTapped))
        navigationBar.topItem?.rightBarButtonItem = cancelButton
    }
    
    //MARK: - Actions
    
    @objc internal func cancelButtonTapped() {
        cancelClosure?()
    }
}
