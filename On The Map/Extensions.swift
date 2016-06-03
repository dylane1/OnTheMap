//
//  Extensions.swift
//  On The Map
//
//  Created by Dylan Edwards on 5/25/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

extension String {
    var isEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}"
        let emailTest  = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(self)
    }
}
