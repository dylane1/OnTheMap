//
//  IconProvider.swift
//  On The Map
//
//  Created by Dylan Edwards on 7/10/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//
/// Icon bezier drawing code generated in PaintCode

import UIKit

enum Icon: String {
    case Pin
    case Map
    case List
    case LocationMarker
}

protocol IconProviderProtocol {
    func imageOfDrawnIcon(icon: Icon, size: CGSize, fillColor: UIColor) -> UIImage
}

struct IconProvider { }

extension IconProvider: IconProviderProtocol, PinIconDrawable, MapIconDrawable, ListIconDrawable, LocationMarkerIconDrawable {
    func imageOfDrawnIcon(icon: Icon, size: CGSize, fillColor: UIColor) -> UIImage {
        var image: UIImage {
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width, size.height), false, 0)
            
            switch icon {
            case .Pin:
                draw32PointPinWithColor(fillColor)
            case .Map:
                draw30PointMapWithColor(fillColor)
            case .List:
                draw30PointListWithColor(fillColor)
            case .LocationMarker:
                drawLocationMarkerWithColor(fillColor)
            }
            
            let img = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            
            return img
        }
        return image
    }
}



































