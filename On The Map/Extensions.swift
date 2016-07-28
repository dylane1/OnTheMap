//
//  Extensions.swift
//  On The Map
//
//  Created by Dylan Edwards on 5/25/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//
import MapKit
import UIKit

//MARK: - String

extension String {
    var isEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}"
        let emailTest  = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(self)
    }
    
    var safariOpenableURL: NSURL? {
        guard var url = NSURL(string: self) else {
            return nil
        }
        
        /// Test for valid scheme
        if !(["http", "https"].contains(url.scheme.lowercaseString)) {
            let appendedLink = "http://".stringByAppendingString(self)
            url = NSURL(string: appendedLink)!
        }
        
        return url
    }
}

//MARK: - UIImage
extension UIImage {
    
    enum AssetIdentifier: String {
        case Map_iPhone4s, Map_iPhone5, Map_iPhone6, Map_iPhone6Plus
    }
    
    convenience init!(assetIdentifier: AssetIdentifier) {
        self.init(named: assetIdentifier.rawValue)
    }
}


//MARK: - Reusable Views
/**
 Adapted from Natasha "The Robot"'s WWDC 2016 POP talk:
 
 https://realm.io/news/appbuilders-natasha-muraschev-practical-protocol-oriented-programming
 */
extension UITableViewCell: ReusableView { }
extension MKAnnotationView: ReusableView { }

//MARK: -  UITableView

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell where T: ReusableView>(forIndexPath indexPath: NSIndexPath) -> T {
        guard let cell = dequeueReusableCellWithIdentifier(T.reuseIdentifier, forIndexPath: indexPath) as? T else {
            fatalError("No way, Jose... could not dequeue cell w/ identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
}
