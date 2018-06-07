//
//  StudentInformationGettable.swift
//  On The Map
//
//  Created by Dylan Edwards on 6/15/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

protocol StudentInformationGettable { }

extension StudentInformationGettable where Self: UIViewController, Self: AlertPresentable, Self: ActivityIndicatorPresentable {
    fileprivate var studentInformationProvider: StudentInformationProvider {
        return StudentInformationProvider.sharedInstance
    }
    
    fileprivate func getStudentInformation(withCompletion completion: () -> Void, alertPresentationClosure alertPresentation: AlertPresentation) {
        studentInformationProvider.configure(withInformationReceivedCompletion: completion, alertPresentationClosure: alertPresentation)
    }
    
    internal func performFetchWithCompletion(_ completion: () -> Void) {
        let fetchFailed = { [weak self] (parameters: AlertParameters) in
            self!.presentAlertWithParameters(parameters)
        }
        getStudentInformation(withCompletion: completion, alertPresentationClosure: fetchFailed)
    }
}
