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
        if let url = link.openableURL {
            let vc = SFSafariViewController(URL: url, entersReaderIfAvailable: true)
            presentViewController(vc, animated: true, completion: nil)
        } else {
            magic("INVALID URL")
        }
    }
}
