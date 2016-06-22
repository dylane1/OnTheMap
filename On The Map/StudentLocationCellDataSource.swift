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
    var textAttributes: [String : AnyObject] { get }
}

extension StudentLocationCellDataSource {
    var textAttributes: [String : AnyObject] {
        return [
            NSForegroundColorAttributeName: Constants.ColorScheme.black,
//            NSStrokeColorAttributeName:     Constants.ColorScheme.black,
//            NSStrokeWidthAttributeName:     -3.0
        ]
    }
}

struct StudentLocationCellModel: StudentLocationCellDataSource {
    var image: UIImage
    var studentInformation: StudentInformation
}
