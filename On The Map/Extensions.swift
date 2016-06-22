//
//  Extensions.swift
//  On The Map
//
//  Created by Dylan Edwards on 5/25/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//
import MapKit
import UIKit

extension String {
    var isEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}"
        let emailTest  = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(self)
    }
    
    var openableURL: NSURL? {
        if let url = NSURL(string: self) where UIApplication.sharedApplication().canOpenURL(url) {
            return url
        } else {
            return nil
        }
    }
    

}

/**
 Adapted from Natasha "The Robot"'s WWDC POP talk:
 
 https://realm.io/news/appbuilders-natasha-muraschev-practical-protocol-oriented-programming
 */
extension UITableViewCell: ReusableView { }
extension MKAnnotationView: ReusableView { }

//extension UITableView {
//    func register<T: UITableViewCell where T: ReusableView, T: NibLoadableView>(_: T.Type) {
//        let nib = UINib(nibName: T.nibName, bundle: nil)
//        registerNib(nib, forCellReuseIdentifier: T.reuseIdentifier)
//    }
//}

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell where T: ReusableView>(forIndexPath indexPath: NSIndexPath) -> T {
        guard let cell = dequeueReusableCellWithIdentifier(T.reuseIdentifier, forIndexPath: indexPath) as? T else {
            fatalError("No way, Jose... could not dequeue cell w/ identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
}
