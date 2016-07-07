//
//  PrimaryActivityIndicatorViewController.swift
//  On The Map
//
//  Created by Dylan Edwards on 7/6/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//
import UIKit

class PrimaryActivityIndicatorViewController: UIViewController, Dimmable, SegueHandlerType {
    
    enum SegueIdentifier: String {
        case ShowLoginActivityIndicatorPopover
    }
    
    internal var vcShouldBeDismissed: (() -> Void)?
    
    let dimLevel: CGFloat = 0.5
    let dimSpeed: Double = 0.5
    
    override func viewDidLoad() { super.viewDidLoad() }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        performSegueWithIdentifier(.ShowLoginActivityIndicatorPopover, sender: self)
    }
    
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        dim(.In, alpha: dimLevel, speed: dimSpeed)
    }
}
