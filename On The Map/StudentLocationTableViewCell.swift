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
        
        configureLabels()
        configureLocationButton()
        configureCell()
    }
    
//    private func configureImageView() {
//        iconImageView.backgroundColor = UIColor.clearColor()
//        iconImageView.image = dataSource.image
//    }
    
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
        
        /**
         Show URLs that won't open in Safari in a red color & Set disclosure
         indicator color to disabled state
        */
        /**
         let pinButton   = UIButton(type: .System)
         pinButton.frame    = CGRectMake(0, 0, 44, 44)
         pinButton.addTarget(self, action: #selector(addButtonTapped), forControlEvents: UIControlEvents.TouchUpInside)
         
         let iconProvider = IconProvider()
         let pinImage = iconProvider.imageOfDrawnIcon(.Pin, size: CGSize(width: 32, height: 32), fillColor: Theme03.tabBarItemUnselected)
         
         pinButton.setImage(pinImage, forState: .Normal)
         
         
         cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accessory.png"]];
 */
        //
        
        let iconProvider = IconProvider()
    
        let disclosureIndicatorImage: UIImage!
        
        if subTitle.safariOpenableURL == nil {
            isInvalidURL = true
            
            subtitleAttributes[NSForegroundColorAttributeName] = Theme03.textError
            
            disclosureIndicatorImage = iconProvider.imageOfDrawnIcon(.DisclosureIndicator, size: CGSize(width: 20, height: 20), fillColor: Theme03.disclosureIndicatorDisabled)
        } else {
            isInvalidURL = false
            
            disclosureIndicatorImage = iconProvider.imageOfDrawnIcon(.DisclosureIndicator, size: CGSize(width: 20, height: 20), fillColor: Theme03.disclosureIndicatorEnabled)
        }
        
        configureDisclosureIndicatorWithImage(disclosureIndicatorImage)
        
        let subtitleAttributedString = NSMutableAttributedString(string: subTitle, attributes: subtitleAttributes)
        
        subtitleLabel.attributedText = subtitleAttributedString
    }
    
    private func configureDisclosureIndicatorWithImage(image: UIImage) {
        iconImageView.backgroundColor = UIColor.clearColor()
        iconImageView.image = image
    }
    
    private func configureLocationButton() {
        let iconProvider = IconProvider()
        
//        let locationMarkerImage = iconProvider.imageOfDrawnIcon(.LocationMarker30Point, size: CGSize(width: 30, height: 30), fillColor: Theme03.locationMarker)
//        
//        showLocationButton.setImage(locationMarkerImage, forState: .Normal)
        let mapButtonImage = iconProvider.imageOfDrawnIcon(.MapButton, size: CGSize(width: 30, height: 50), fillColor: Theme03.locationMarker)
        
        showLocationButton.setImage(mapButtonImage, forState: .Normal)
        
        showLocationButton.setTitle(nil, forState: .Normal)
        showLocationButton.tintColor = Theme03.locationMarker
    }
    
    
    private func configureCell() {
        
//        backgroundColor = (isInvalidURL) ? Constants.ColorScheme.lightGrey : UIColor.clearColor()
    }

}











































