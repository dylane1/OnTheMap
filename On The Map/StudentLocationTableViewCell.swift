//
//  StudentLocationTableViewCell.swift
//  On The Map
//
//  Created by Dylan Edwards on 6/16/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

class StudentLocationTableViewCell: UITableViewCell /*, NibLoadableView*/ {
    
    private var presentMapViewController: ((locationName: String, latitude: Double, longitude: Double) -> Void)!
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet weak var showLocationButton: UIButton!
    
    private var dataSource: StudentLocationCellDataSource!
    
    private var isInvalidURL = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    //MARK: - Actions
    
    @IBAction func showLocationAction(sender: AnyObject) {
        presentMapViewController?(locationName: dataSource.studentInformation.mapString, latitude: dataSource.studentInformation.latitude, longitude: dataSource.studentInformation.longitude)
    }
    
    //MARK: - Configuration
    
    internal func configure(withDataSource dataSource: StudentLocationCellDataSource, presentMapViewController: (locationName: String, latitude: Double, longitude: Double) -> Void) {
        
        self.dataSource                 = dataSource
        self.presentMapViewController   = presentMapViewController
        backgroundColor                 = UIColor.clearColor()
        configureImageView()
        configureLabels()
        configureCell()
    }
    
    private func configureImageView() {
        iconImageView.backgroundColor = UIColor.clearColor()
        iconImageView.image = dataSource.image
    }
    
    private func configureLabels() {
        /// Title label
        titleLabel.adjustsFontSizeToFitWidth  = true
        
        let titleAttributes = dataSource.titleTextAttributes
        
        let fn = dataSource.studentInformation.firstName
        let ln = dataSource.studentInformation.lastName
        
        let fullName = fn + " " + ln
        
        let titleAttributedString = NSMutableAttributedString(string: fullName, attributes: titleAttributes)
        
        titleLabel.attributedText = titleAttributedString
        
        /// Subtitle label
        subtitleLabel.adjustsFontSizeToFitWidth  = true
        
        var subtitleAttributes = dataSource.subtitleTextAttributes
        
        let subTitle = dataSource.studentInformation.mediaURL
        
        /// Show URLs that won't open in Safari in a red color
        if subTitle.safariOpenableURL == nil {
            subtitleAttributes[NSForegroundColorAttributeName] = Theme03.textError
            isInvalidURL = true
        } else {
            isInvalidURL = false
        }
        
        let subtitleAttributedString = NSMutableAttributedString(string: subTitle, attributes: subtitleAttributes)
        
        subtitleLabel.attributedText = subtitleAttributedString
    }
    
    private func configureCell() {
        
//        backgroundColor = (isInvalidURL) ? Constants.ColorScheme.lightGrey : UIColor.clearColor()
    }

}
