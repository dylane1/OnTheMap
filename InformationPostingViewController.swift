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
    private var alertPresentationClosure: AlertPresentationClosure!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let navController = navigationController! as! NavigationController
        navController.setNavigationBarAttributes(isAppTitle: false)
        
        configureAlertClosure()
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
        
        
        postingView.configure(withSuccessClosure: submitSuccessfulClosure, alertPresentationClosure: alertPresentationClosure)
    }
    
    private func configureAlertClosure() {
        alertPresentationClosure = { [unowned self] (alertTitle: String, alertMessage: String) in
            
            let alert = UIAlertController(
                title: alertTitle,
                message: alertMessage,
                preferredStyle: .Alert)

            alert.addAction(UIAlertAction(title: LocalizedStrings.AlertButtonTitles.ok, style: .Default) { (alert: UIAlertAction!) in
//                /** Remove meme from storage & Table or Collection view */
//                self.deleteClosure?()
//                
//                /** Remove image from view */
//                self.savedMemeView.imageView.image = nil
//                
//                /** Close This View Controller */
//                self.navigationController?.popToRootViewControllerAnimated(true)
                })
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
}
