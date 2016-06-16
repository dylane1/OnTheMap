//
//  StudentLocationTableViewCell.swift
//  On The Map
//
//  Created by Dylan Edwards on 6/16/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

class StudentLocationTableViewCell: UITableViewCell {
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    
    private var dataSource: StudentLocationDataSource!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    //MARK: - Configuration
    
    internal func configure(withDataSource dataSource: StudentLocationDataSource) {
        self.dataSource = dataSource
        configureImageView()
        configureLabel()
        configureCell()
    }
    
    private func configureImageView() {
//        iconImageView.backgroundColor = Constants.ColorScheme.darkGrey
        iconImageView.image = dataSource.image
    }
    
    private func configureLabel() {
        nameLabel.adjustsFontSizeToFitWidth  = true
        
        let attributes = dataSource.textAttributes
//        attributes[NSFontAttributeName] = dataSource.meme.font
        
        let fn = dataSource.studentInformation.firstName
        let ln = dataSource.studentInformation.lastName
        
        let fullName = fn + " " + ln
        
        let attributedString = NSMutableAttributedString(string: fullName, attributes: attributes)
        
        nameLabel.attributedText = attributedString
    }
    
    private func configureCell() {
//        backgroundColor = Constants.ColorScheme.whiteAlpha50
    }

}
