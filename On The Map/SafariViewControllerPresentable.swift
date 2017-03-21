//
//  SafariViewControllerPresentable.swift
//  On The Map
//
//  Created by Dylan Edwards on 6/16/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit
import SafariServices

protocol SafariViewControllerPresentable { }

extension SafariViewControllerPresentable where Self: UIViewController {
    func openLinkInSafari(withURLString link: String) {
        
        guard let url = link.safariOpenableURL else {
            return
        }
        
        let safariViewController = SFSafariViewController(url: url as URL)
        present(safariViewController, animated: true, completion: nil)
    }
}
