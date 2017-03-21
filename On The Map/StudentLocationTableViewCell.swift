//
//  StudentLocationTableViewCell.swift
//  On The Map
//
//  Created by Dylan Edwards on 6/16/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

class StudentLocationTableViewCell: UITableViewCell /*, NibLoadableView*/ {
    
    fileprivate var presentMapViewController: ((_ locationName: String, _ latitude: Double, _ longitude: Double) -> Void)!
    
    @IBOutlet fileprivate weak var nameLabel: UILabel!
    @IBOutlet fileprivate weak var locationLabel: UILabel!
    @IBOutlet fileprivate weak var linkLabel: UILabel!
    @IBOutlet fileprivate weak var iconImageView: UIImageView!
    @IBOutlet weak var showLocationButton: UIButton!
    
    fileprivate var dataSource: StudentLocationCellDataSource!
    
    fileprivate var isInvalidURL = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    //MARK: - Actions
    
    @IBAction func showLocationAction(_ sender: AnyObject) {
        presentMapViewController?(dataSource.studentInformation.mapString, dataSource.studentInformation.latitude, dataSource.studentInformation.longitude)
    }
    
    //MARK: - Configuration
    
    internal func configure(withDataSource dataSource: StudentLocationCellDataSource, presentMapViewController: @escaping (_ locationName: String, _ latitude: Double, _ longitude: Double) -> Void) {
        
        self.dataSource                 = dataSource
        self.presentMapViewController   = presentMapViewController
        backgroundColor                 = UIColor.clear
        
        configureLabels()
        configureLocationButton()
    }
    
    fileprivate func configureLabels() {
        /// Name label
        nameLabel.adjustsFontSizeToFitWidth  = true
        
        let nameTextAttributes = dataSource.nameTextAttributes
        
        let fn = dataSource.studentInformation.firstName
        let ln = dataSource.studentInformation.lastName
        
        let fullName = fn! + " " + ln!
        
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
    
        if linkText?.safariOpenableURL == nil {
            isInvalidURL = true
            
            linkTextAttributes[NSForegroundColorAttributeName] = Theme.textError
            
            disclosureIndicatorImage = IconProvider.imageOfDrawnIcon(.DisclosureIndicator, size: CGSize(width: 20, height: 20), fillColor: Theme.disclosureIndicatorDisabled)
        } else {
            isInvalidURL = false
            
            linkTextAttributes[NSUnderlineStyleAttributeName] = NSUnderlineStyle.styleSingle.rawValue as AnyObject?
            
            disclosureIndicatorImage = IconProvider.imageOfDrawnIcon(.DisclosureIndicator, size: CGSize(width: 20, height: 20), fillColor: Theme.disclosureIndicatorEnabled)
        }
        
        configureDisclosureIndicatorWithImage(disclosureIndicatorImage)
        
        let linkTextAttributedString = NSMutableAttributedString(string: linkText!, attributes: linkTextAttributes)
        
        linkLabel.attributedText = linkTextAttributedString
    }
    
    fileprivate func configureDisclosureIndicatorWithImage(_ image: UIImage) {
        iconImageView.backgroundColor = UIColor.clear
        iconImageView.image = image
    }
    
    fileprivate func configureLocationButton() {
        
        let mapButtonImage = IconProvider.imageOfDrawnIcon(.MapButton, size: CGSize(width: 30, height: 50), fillColor: Theme.locationMarker)
        
        showLocationButton.setImage(mapButtonImage, for: UIControlState())
        
        showLocationButton.setTitle(nil, for: UIControlState())
        showLocationButton.tintColor = Theme.locationMarker
    }
}
