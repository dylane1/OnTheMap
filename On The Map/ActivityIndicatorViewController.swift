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
    
    @IBOutlet weak var popupView: ActivityIndicatorView!
    
    override func viewDidLoad() {
//        let theView = popupView as! ActivityIndicatorView
        
        super.viewDidLoad()
//        popupView.backgroundColor = UIColor.clearColor()
        popupView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.001)
        popupView.layer.cornerRadius = 40
        popupView.layer.shadowColor = UIColor.blackColor().CGColor //Theme03.shadowDark.CGColor
        popupView.layer.shadowOpacity = 0.9
        popupView.layer.shadowRadius = 10
        popupView.layer.shadowOffset = CGSize(width: 5, height: 5)
        popupView.layer.masksToBounds = false
        
//        popupView.configure()
    }
    
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
}
