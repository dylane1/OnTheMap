//
//  StudentInformationGettable.swift
//  On The Map
//
//  Created by Dylan Edwards on 6/15/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

protocol StudentInformationGettable { }

extension StudentInformationGettable where Self: UIViewController, Self: AlertPresentable {
    private var studentInformationProvider: StudentInformationProvider {
        return StudentInformationProvider.sharedInstance
    }
    
    internal func getStudentInformation(withCompletion completion: () -> Void) {
        studentInformationProvider.configure(withInformationReceivedCompletion: completion, alertPresentationClosure: self.getAlertPresentationClosure())
    }
}
