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
    
    private var studentInformationArray = [StudentInformation]()
    private var annotations = [StudentLocationAnnotation]()
    
    private var openLinkClosure: OpenLinkClosure?
    
    private var mapRendered = false
    
    //MARK: - Configuration
    
    internal func configure(withStudentInformationArray array: [StudentInformation], openLinkClosure closure: OpenLinkClosure) {
        
        mapView.delegate    = self
        
        studentInformationArray = array
        openLinkClosure         = closure
        
        /// clear for refresh
        clearAnnotations()
        
        if mapRendered { placeAnnotations(withStudentInformationArray: array) }
    }
    
    //MARK: - Map View
    
    private func placeAnnotations(withStudentInformationArray array: [StudentInformation]) {
        for item in array {
            let annotation = StudentLocationAnnotation(title: (item.firstName + " " + item.lastName), mediaURL: item.mediaURL,locationName: item.mapString, coordinate: CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude))
            annotations.append(annotation)
        }

        mapView.addAnnotations(annotations)
    }
    
    private func clearAnnotations() {
        if annotations.count > 0 {
            mapView.removeAnnotations(annotations)
            annotations.removeAll()
        }
    }
}

extension StudentLocationMapContainerView: MKMapViewDelegate {
    
    func mapViewDidFinishRenderingMap(mapView: MKMapView, fullyRendered: Bool) {
        mapRendered = true
        placeAnnotations(withStudentInformationArray: studentInformationArray)
//        if urlTextField.alpha == 0 && placemarks != nil {
//            animateURLTextFieldIntoView()
//        }
    }
    
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
