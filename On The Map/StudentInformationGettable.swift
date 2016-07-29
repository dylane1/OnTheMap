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
    private var studentInformationProvider: StudentInformationProvider {
        return StudentInformationProvider.sharedInstance
    }
    
    private func getStudentInformation(withCompletion completion: (studentInfoArray: [StudentInformation]) -> Void, alertPresentationClosure alertPresentation: AlertPresentation) {
        studentInformationProvider.configure(withInformationReceivedCompletion: completion, alertPresentationClosure: alertPresentation)
    }
    
    internal func performFetchWithCompletion(completion: (studentInfoArray: [StudentInformation]) -> Void) {
        let fetchFailed = { (parameters: AlertParameters) in
            self.presentAlertWithParameters(parameters)
        }
        getStudentInformation(withCompletion: completion, alertPresentationClosure: fetchFailed)
    }
}
