//
//  InformationPostingViewController.swift
//  On The Map
//
//  Created by Dylan Edwards on 6/9/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

class InformationPostingViewController: UIViewController, InformationPostingNavigationProtocol {
    private var postingView: InformationPostingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let navController = navigationController! as! NavigationController
        navController.setNavigationBarAttributes(isAppTitle: false)
        
//        title = LocalizedStrings.ViewControllerTitles.whereAreYou
        
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
        
        postingView.configure()
    }
    
    
}
