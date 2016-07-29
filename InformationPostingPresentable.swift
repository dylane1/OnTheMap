//
//  InformationPostingPresentable.swift
//  On The Map
//
//  Created by Dylan Edwards on 6/9/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

protocol InformationPostingPresentable {
    var informationPostingNavController: InformationPostingNavigationController? { get set }
}

extension InformationPostingPresentable where Self: UIViewController {
    internal func getInfoPostingNavigationController() -> InformationPostingNavigationController {
        let infoPostingNavController = UIStoryboard(name: Constants.StoryBoardID.main, bundle: nil).instantiateViewControllerWithIdentifier(Constants.StoryBoardID.infoPostingNavController) as! InformationPostingNavigationController
        
        return infoPostingNavController
    }
}
