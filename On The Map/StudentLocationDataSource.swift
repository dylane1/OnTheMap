//
//  StudentLocationDataSource.swift
//  On The Map
//
//  Created by Dylan Edwards on 6/16/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

protocol StudentLocationDataSource {
    var image: UIImage { get }
    var studentInformation: StudentInformation { get }
    var textAttributes: [String : AnyObject] { get }
}

extension StudentLocationDataSource {
    var textAttributes: [String : AnyObject] {
        return [
            NSForegroundColorAttributeName: Constants.ColorScheme.black,
//            NSStrokeColorAttributeName:     Constants.ColorScheme.black,
//            NSStrokeWidthAttributeName:     -3.0
        ]
    }
}

struct StudentLocationCellModel: StudentLocationDataSource {
    var image: UIImage
    var studentInformation: StudentInformation
}
