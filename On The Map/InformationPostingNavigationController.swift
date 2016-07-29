//
//  InformationPostingNavigationController.swift
//  On The Map
//
//  Created by Dylan Edwards on 6/9/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

final class InformationPostingNavigationController: NavigationController {
    
    private var cancelClosure: BarButtonClosure?
    private var cancelButton: UIBarButtonItem?
    
//    deinit { magic("\(self.description) is being deinitialized   <----------------") }
    
    //MARK: - Configuration
    
    internal func configure(withCancelClosure cancel: BarButtonClosure) {
        cancelClosure = cancel
        
        configureNavigationItems()
    }
    
    private func configureNavigationItems() {
        cancelButton = UIBarButtonItem(
            barButtonSystemItem: .Cancel,
            target: self,
            action: #selector(cancelButtonTapped))
        navigationBar.topItem?.rightBarButtonItem = cancelButton
    }
    
    //MARK: - Actions
    
    internal func cancelButtonTapped() {
        cancelClosure?()
    }
}
