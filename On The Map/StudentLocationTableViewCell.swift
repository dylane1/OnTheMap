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
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var linkLabel: UILabel!
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
        
        configureLabels()
        configureLocationButton()
    }
    
    private func configureLabels() {
        /// Name label
        nameLabel.adjustsFontSizeToFitWidth  = true
        
        let nameTextAttributes = dataSource.nameTextAttributes
        
        let fn = dataSource.studentInformation.firstName
        let ln = dataSource.studentInformation.lastName
        
        let fullName = fn + " " + ln
        
        let nameAttributedString = NSMutableAttributedString(string: fullName, attributes: nameTextAttributes)
        
        nameLabel.attributedText = nameAttributedString
        
        /// Location label
        locationLabel.adjustsFontSizeToFitWidth  = true
        
        let locationTextAttributes = dataSource.locationTextAttributes
        
        let locationAttributedString = NSMutableAttributedString(string: dataSource.studentInformation.mapString, attributes: locationTextAttributes)

        locationLabel.attributedText = locationAttributedString
        
        /// Link label
        /**
         Show URLs that won't open in Safari in a red color & Set disclosure
         indicator color to disabled state
        */
        let linkText = dataSource.studentInformation.mediaURL
        var linkTextAttributes = dataSource.linkTextAttributes
        
//        let iconProvider = IconProvider()
        let disclosureIndicatorImage: UIImage!
    
        if linkText.safariOpenableURL == nil {
            isInvalidURL = true
            
            linkTextAttributes[NSForegroundColorAttributeName] = Theme03.textError
            
            disclosureIndicatorImage = IconProvider.imageOfDrawnIcon(.DisclosureIndicator, size: CGSize(width: 20, height: 20), fillColor: Theme03.disclosureIndicatorDisabled)
        } else {
            isInvalidURL = false
            
            linkTextAttributes[NSUnderlineStyleAttributeName] = NSUnderlineStyle.StyleSingle.rawValue
            
            disclosureIndicatorImage = IconProvider.imageOfDrawnIcon(.DisclosureIndicator, size: CGSize(width: 20, height: 20), fillColor: Theme03.disclosureIndicatorEnabled)
        }
        
        configureDisclosureIndicatorWithImage(disclosureIndicatorImage)
        
        let linkTextAttributedString = NSMutableAttributedString(string: linkText, attributes: linkTextAttributes)
        
        linkLabel.attributedText = linkTextAttributedString
    }
    
    private func configureDisclosureIndicatorWithImage(image: UIImage) {
        iconImageView.backgroundColor = UIColor.clearColor()
        iconImageView.image = image
    }
    
    private func configureLocationButton() {
//        let iconProvider = IconProvider()
        
        let mapButtonImage = IconProvider.imageOfDrawnIcon(.MapButton, size: CGSize(width: 30, height: 50), fillColor: Theme03.locationMarker)
        
        showLocationButton.setImage(mapButtonImage, forState: .Normal)
        
        showLocationButton.setTitle(nil, forState: .Normal)
        showLocationButton.tintColor = Theme03.locationMarker
    }
}
