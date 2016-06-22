//
//  StudentLocationMapContainerView.swift
//  On The Map
//
//  Created by Dylan Edwards on 6/16/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import MapKit
import UIKit

class StudentLocationMapContainerView: UIView {

    @IBOutlet weak var mapView: MKMapView!
    
    private var annotations = [StudentLocationAnnotation]()
    
    private var openLinkClosure: OpenLinkClosure?
    //MARK: - Configuration
    
    internal func configure(withStudentInfoArray array: [StudentInformation], openLinkClosure closure: OpenLinkClosure) {
        mapView.delegate    = self
        openLinkClosure     = closure
        
        placeAnnotations(withStudentInfoArray: array)
    }

    
    //MARK: - 
    
    private func placeAnnotations(withStudentInfoArray array: [StudentInformation]) {
        for item in array {
            let annotation = StudentLocationAnnotation(title: (item.firstName + " " + item.lastName), mediaURL: item.mediaURL,locationName: item.mapString, coordinate: CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude))
            annotations.append(annotation)
        }

        mapView.addAnnotations(annotations)
    }
    
    internal func clearAnnotations() {
        if annotations.count > 0 {
            mapView.removeAnnotations(annotations)
            annotations.removeAll()
        }
    }
}

extension StudentLocationMapContainerView: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? StudentLocationAnnotation {
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(MKPinAnnotationView.reuseIdentifier)
                as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: MKPinAnnotationView.reuseIdentifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
            }
            return view
        }
        return nil
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let annotation = view.annotation as! StudentLocationAnnotation
        openLinkClosure?(annotation.mediaURL)
    }
}
