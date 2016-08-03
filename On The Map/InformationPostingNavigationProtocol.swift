//
//  InformationPostingNavigationProtocol.swift
//  On The Map
//
//  Created by Dylan Edwards on 6/9/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

protocol InformationPostingNavigationProtocol { }

extension InformationPostingNavigationProtocol where Self: UIViewController {
    internal var informationPostingNavigationController: InformationPostingNavigationController {
        return navigationController as! InformationPostingNavigationController
    }
    
    internal func configureNavigationItems() {
        let cancelButtonClosure = { [weak self] in
            self!.dismissViewControllerAnimated(true, completion: nil)
        }
        informationPostingNavigationController.configure(withCancelClosure: cancelButtonClosure)
    }
}
