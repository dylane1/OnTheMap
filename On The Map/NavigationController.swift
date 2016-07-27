//
//  NavigationController.swift
//  On The Map
//
//  Created by Dylan Edwards on 5/18/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
    /// Set by presenting view controller
    internal var vcShouldBeDismissed: (() -> Void)?
    
    internal func setNavigationBarAttributes(isAppTitle isTitle: Bool) {
        
        navigationBar.barTintColor = Theme03.barTintColor
        navigationBar.tintColor    = Theme03.buttonTint
        navigationBar.translucent  = true
        
        let shadow = NSShadow()
        shadow.shadowColor = Theme03.shadowDark
        shadow.shadowOffset = CGSize(width: -1.0, height: -1.0)
        
        var titleLabelAttributes: [String : AnyObject] = [NSForegroundColorAttributeName : Theme03.textLight]
        
        if isTitle {
            /* titleLabelAttributes[NSShadowAttributeName] = shadow */
            titleLabelAttributes[NSFontAttributeName] = UIFont(name: Constants.FontName.markerFelt, size: 24)!
        } else {
            titleLabelAttributes[NSFontAttributeName] = UIFont.systemFontOfSize(14, weight: UIFontWeightMedium)
        }
        
        navigationBar.titleTextAttributes = titleLabelAttributes
    }
}
