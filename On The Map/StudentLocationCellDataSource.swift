//
//  StudentLocationCellDataSource.swift
//  On The Map
//
//  Created by Dylan Edwards on 6/16/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

protocol StudentLocationCellDataSource {
    var image: UIImage { get }
    var studentInformation: StudentInformation { get }
    var titleTextAttributes: [String : AnyObject] { get }
    var subtitleTextAttributes: [String : AnyObject] { get }
}

extension StudentLocationCellDataSource {
    internal var titleTextAttributes: [String : AnyObject] {
        return [
            NSForegroundColorAttributeName: Constants.ColorScheme.black,
            NSFontAttributeName: UIFont.systemFontOfSize(17, weight: UIFontWeightLight)
        ]
    }
    internal var subtitleTextAttributes: [String : AnyObject] {
        return [
            NSForegroundColorAttributeName: Constants.ColorScheme.black,
            NSFontAttributeName: UIFont.systemFontOfSize(14, weight: UIFontWeightLight)
        ]
    }
}

struct StudentLocationCellModel: StudentLocationCellDataSource {
    var image: UIImage
    var studentInformation: StudentInformation
}
