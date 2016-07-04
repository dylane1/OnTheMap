//
//  InformationPostingViewController.swift
//  On The Map
//
//  Created by Dylan Edwards on 6/9/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

class InformationPostingViewController: UIViewController, InformationPostingNavigationProtocol, AlertPresentable {
    private var postingView: InformationPostingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = LocalizedStrings.ViewControllerTitles.enterYourLocation
        
        let navController = navigationController! as! NavigationController
        navController.setNavigationBarAttributes(isAppTitle: false)
        
        configureView()
        configureNavigationItems()
    }
    
    //MARK: - Configuration
    
    private func configureView() {
        postingView = view as! InformationPostingView
        
        let submitSuccessfulClosure = { [weak self] in
            self!.dismissViewControllerAnimated(true, completion: nil)
        }
        
        postingView.configure(withSuccessClosure: submitSuccessfulClosure, alertPresentationClosure: getAlertPresentationClosure())
    }
}
