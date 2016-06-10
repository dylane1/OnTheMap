//
//  InformationPostingNavigationProtocol.swift
//  On The Map
//
//  Created by Dylan Edwards on 6/9/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

protocol InformationPostingNavigationProtocol {
    var informationPostingNavController: InformationPostingNavigationController { get }
}

extension InformationPostingNavigationProtocol where Self: UIViewController {
    var informationPostingNavController: InformationPostingNavigationController {
        return navigationController as! InformationPostingNavigationController
    }
    
    internal func configureNavigationItems() {
        let cancelButtonClosure = { [weak self] in
            self!.dismissViewControllerAnimated(true, completion: nil)
        }
        informationPostingNavController.configure(withCancelClosure: cancelButtonClosure)
    }
}
