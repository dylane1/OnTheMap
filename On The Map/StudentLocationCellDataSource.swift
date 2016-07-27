//
//  StudentLocationCellDataSource.swift
//  On The Map
//
//  Created by Dylan Edwards on 6/16/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

protocol StudentLocationCellDataSource {
    var studentInformation: StudentInformation { get }
    var nameTextAttributes: [String : AnyObject] { get }
    var locationTextAttributes: [String : AnyObject] { get }
    var linkTextAttributes: [String : AnyObject] { get }
}

extension StudentLocationCellDataSource {
    internal var nameTextAttributes: [String : AnyObject] {
        return [
            NSForegroundColorAttributeName: Theme.textDark,
            NSFontAttributeName: UIFont(name: Constants.FontName.avenirHeavy, size: 20)!
        ]
    }
    internal var locationTextAttributes: [String : AnyObject] {
        return [
            NSForegroundColorAttributeName: Theme.textDark,
            NSFontAttributeName: UIFont(name: Constants.FontName.avenirMedium, size: 16)!
        ]
    }
    internal var linkTextAttributes: [String : AnyObject] {
        return [
            NSForegroundColorAttributeName: Theme.textLink,
            NSFontAttributeName: UIFont(name: Constants.FontName.avenirMedium, size: 14)!
        ]
    }
}

struct StudentLocationCellModel: StudentLocationCellDataSource {
    var studentInformation: StudentInformation
}
