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
            NSForegroundColorAttributeName: Theme03.textDark,
            NSFontAttributeName: UIFont.systemFontOfSize(20, weight: UIFontWeightMedium)
        ]
    }
    internal var locationTextAttributes: [String : AnyObject] {
        return [
            NSForegroundColorAttributeName: Theme03.textDark,
            NSFontAttributeName: UIFont.systemFontOfSize(16, weight: UIFontWeightMedium)
        ]
    }
    internal var linkTextAttributes: [String : AnyObject] {
        return [
            NSForegroundColorAttributeName: Theme03.textLink,
            NSFontAttributeName: UIFont.systemFontOfSize(14, weight: UIFontWeightLight)
        ]
    }
}

struct StudentLocationCellModel: StudentLocationCellDataSource {
    var studentInformation: StudentInformation
}
