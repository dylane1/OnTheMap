//
//  ActivityIndicatorViewController.swift
//  On The Map
//
//  Created by Dylan Edwards on 7/7/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

class ActivityIndicatorViewController: UIViewController /*, SegueHandlerType*/{
    
    @IBOutlet weak var popupView: ActivityIndicatorView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        popupView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.001)
        popupView.layer.cornerRadius = popupView.bounds.height / 2
        popupView.layer.shadowColor = UIColor.black.cgColor
        popupView.layer.shadowOpacity = 0.9
        popupView.layer.shadowRadius = 10
        popupView.layer.shadowOffset = CGSize(width: 5, height: 5)
        popupView.layer.masksToBounds = false
    }
}
