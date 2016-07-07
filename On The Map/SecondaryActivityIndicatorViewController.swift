//
//  SecondaryActivityIndicatorViewController.swift
//  On The Map
//
//  Created by Dylan Edwards on 7/7/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

class SecondaryActivityIndicatorViewController: UIViewController, SegueHandlerType {
    
    enum SegueIdentifier: String {
        case UnwindSegue
    }
    
    @IBOutlet weak var popupView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popupView.layer.cornerRadius = 10
        popupView.layer.borderColor = UIColor.blackColor().CGColor
        popupView.layer.borderWidth = 0.25
        popupView.layer.shadowColor = UIColor.blackColor().CGColor
        popupView.layer.shadowOpacity = 0.6
        popupView.layer.shadowRadius = 15
        popupView.layer.shadowOffset = CGSize(width: 5, height: 5)
        popupView.layer.masksToBounds = false
    }
    
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    
    internal func unwindSegue() {
        performSegueWithIdentifier(.UnwindSegue, sender: self)
    }
}
