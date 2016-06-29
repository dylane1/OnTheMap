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
//    private var alertPresentationClosureWithParameters: AlertPresentationClosureWithParameters!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let navController = navigationController! as! NavigationController
        navController.setNavigationBarAttributes(isAppTitle: false)
        
        configureView()
        configureNavigationItems()
    }
    
//    override func viewDidAppear(animated: Bool) {
//        postingView.configurePrompt()
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
