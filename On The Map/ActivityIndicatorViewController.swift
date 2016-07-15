//
//  ActivityIndicatorViewController.swift
//  On The Map
//
//  Created by Dylan Edwards on 7/7/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

class ActivityIndicatorViewController: UIViewController /*, SegueHandlerType*/{
    
//    deinit { magic("being deinitialized   <----------------") }
    
    @IBOutlet weak var popupView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popupView.layer.cornerRadius = 6
        popupView.layer.shadowColor = UIColor.blackColor().CGColor //Theme03.shadowDark.CGColor
        popupView.layer.shadowOpacity = 0.6
        popupView.layer.shadowRadius = 10
        popupView.layer.shadowOffset = CGSize(width: 5, height: 5)
        popupView.layer.masksToBounds = false
    }
    
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
}
