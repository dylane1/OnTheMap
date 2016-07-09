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
    
    private var activityIndicatorOpenedCompletion: (() -> Void)?
    private var activityIndicatorClosedCompletion: (() -> Void)?
    
    private var secondaryViewController: SecondaryActivityIndicatorViewController!
    
    let dimLevel: CGFloat = 0.5
    let dimSpeed: Double = 0.5
    
    override func viewDidLoad() { super.viewDidLoad() }
    
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        secondaryViewController = segue.destinationViewController as! SecondaryActivityIndicatorViewController
        dim(.In, alpha: dimLevel, speed: dimSpeed, completion: activityIndicatorOpenedCompletion)
    }
    
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        dim(.Out, speed: dimSpeed, completion: activityIndicatorClosedCompletion)
    }
    
    //MARK: -
    internal func presentSecondary(withCompletion completion: (() -> Void)? = nil) {
        activityIndicatorOpenedCompletion = completion
        performSegueWithIdentifier(.ShowLoginActivityIndicatorPopover, sender: self)
    }
    
    internal func dismissSecondary(withCompletion completion: (() -> Void)? = nil) {
        activityIndicatorClosedCompletion = completion
        if secondaryViewController != nil {
            secondaryViewController.unwindSegue()
        }
    }
}
