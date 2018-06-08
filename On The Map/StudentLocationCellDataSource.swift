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
    var nameTextAttributes: [NSAttributedStringKey : Any] { get }
    var locationTextAttributes: [NSAttributedStringKey : Any] { get }
    var linkTextAttributes: [NSAttributedStringKey : Any] { get }
}

extension StudentLocationCellDataSource {
    internal var nameTextAttributes: [String : AnyObject] {
        return [
            NSAttributedStringKey.foregroundColor.rawValue: Theme.textDark,
            NSAttributedStringKey.font.rawValue: UIFont(name: Constants.FontName.avenirHeavy, size: 20)!
        ]
    }
    internal var locationTextAttributes: [String : AnyObject] {
        return [
            NSAttributedStringKey.foregroundColor.rawValue: Theme.textDark,
            NSAttributedStringKey.font.rawValue: UIFont(name: Constants.FontName.avenirMedium, size: 16)!
        ]
    }
    internal var linkTextAttributes: [String : AnyObject] {
        return [
            NSAttributedStringKey.foregroundColor.rawValue: Theme.textLink,
            NSAttributedStringKey.font.rawValue: UIFont(name: Constants.FontName.avenirMedium, size: 14)!
        ]
    }
}

struct StudentLocationCellModel: StudentLocationCellDataSource {
    var linkTextAttributes: [NSAttributedStringKey : Any]
    var locationTextAttributes: [NSAttributedStringKey : Any]
    var nameTextAttributes: [NSAttributedStringKey : Any]
    
    var studentInformation: StudentInformation
}
