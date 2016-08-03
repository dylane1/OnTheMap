//
//  AnnotationDrawable.swift
//  On The Map
//
//  Created by Dylan Edwards on 7/26/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

protocol AnnotationDrawable { }

extension AnnotationDrawable where Self: IconProviderProtocol {
    static func drawAnnotationMarker() {
        
        let ovalPath0 = UIBezierPath(ovalInRect: CGRect(x: 1, y: 1, width: 13, height: 13))
        Theme.annotationColor0.setStroke()
        ovalPath0.lineWidth = 1
        ovalPath0.stroke()
        
        let ovalPath1 = UIBezierPath(ovalInRect: CGRect(x: 3, y: 3, width: 9, height: 9))
        Theme.annotationColor1.setStroke()
        ovalPath1.lineWidth = 3
        ovalPath1.stroke()
        
        let ovalPath2 = UIBezierPath(ovalInRect: CGRect(x: 4, y: 4, width: 7, height: 7))
        Theme.annotationColor2.colorWithAlphaComponent(0.7).setFill()
        ovalPath2.fill()
    }
}

