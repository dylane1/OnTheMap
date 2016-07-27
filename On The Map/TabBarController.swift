//
//  TabBarController.swift
//  On The Map
//
//  Created by Dylan Edwards on 5/18/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    deinit { magic("being deinitialized   <----------------") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.barTintColor = Theme03.barTintColor
        tabBar.tintColor = Theme03.buttonTint
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        /// Shift icon down
        for item in viewControllers! {
            item.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        }
//        let iconProvider = IconProvider()
        let mapIcon = IconProvider.imageOfDrawnIcon(.Map, size: CGSize(width: 30, height: 30), fillColor: Theme03.tabBarItemUnselected)
        tabBar.items![0].image          = mapIcon.imageWithRenderingMode(.AlwaysOriginal)
        tabBar.items![0].selectedImage  = mapIcon
        
        let listIcon = IconProvider.imageOfDrawnIcon(.List, size: CGSize(width: 30, height: 30), fillColor: Theme03.tabBarItemUnselected)
        tabBar.items![1].image          = listIcon.imageWithRenderingMode(.AlwaysOriginal)
        tabBar.items![1].selectedImage  = listIcon
    }
}
