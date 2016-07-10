//
//  TabBarController.swift
//  On The Map
//
//  Created by Dylan Edwards on 5/18/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
//    internal var successfulLogoutCompletion: (() -> Void)?
    
    deinit { magic("being deinitialized   <----------------") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.barTintColor = Theme03.barTintColor
        tabBar.tintColor = Theme03.buttonTint
        
        /// Shift icon down
        for item in tabBar.items! {
            item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        }
    }
}
