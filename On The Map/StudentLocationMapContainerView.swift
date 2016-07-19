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

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mapView: MKMapView!
    
    /// Use a preloaded image until map is renedered so user doesn't see empty screen
    @IBOutlet weak var preloadedMapImage: UIImageView!
    private var mapRendered = false
    
    private var studentInformationArray = [StudentInformation]()
    private var annotations = [StudentLocationAnnotation]()
    
    private var openLinkClosure: OpenLinkClosure?
    
    private var animatedPinsIn = false
//    private var timer = NSTimer()
//    private var delay = 0.05
//    private var annotationViewArray: [MKAnnotationView]?
//    private var annotationIndex = 0
    
    //MARK: - Configuration
    
    internal func configure(withStudentInformationArray array: [StudentInformation], openLinkClosure closure: OpenLinkClosure) {
        
        mapView.delegate    = self
        
        studentInformationArray = array
        openLinkClosure         = closure
        
        configureMapImage()
        /// clear for refresh
        clearAnnotations()
        animatedPinsIn = false
        
        if mapRendered {
            placeAnnotations(withStudentInformationArray: array)
        }
    }
    
    /**
     Show a map image on top of map view while it loads so the user doesn't
     see a blank screen
     */
    internal func configureMapImage() {
        preloadedMapImage.alpha = 0.0
        
        let screenHeight = UIScreen.mainScreen().bounds.height
        
        if !mapRendered {
            /// Need to determine map size & load correct image accordingly
            switch screenHeight {
            case Constants.ScreenHeight.iPhone4s:
                preloadedMapImage.image = UIImage(assetIdentifier: .Map_iPhone4s)
            case Constants.ScreenHeight.iPhone5:
                preloadedMapImage.image = UIImage(assetIdentifier: .Map_iPhone5)
            case Constants.ScreenHeight.iPhone6:
                preloadedMapImage.image = UIImage(assetIdentifier: .Map_iPhone6)
            default:
                /// iPhone6Plus
                preloadedMapImage.image = UIImage(assetIdentifier: .Map_iPhone6Plus)
            }
            preloadedMapImage.alpha = 1.0
        }
        
        activityIndicator.color = UIColor.ceSoir()
        activityIndicator.startAnimating()
    }
    
    
    //MARK: - Map View
    
    private func placeAnnotations(withStudentInformationArray array: [StudentInformation]) {
        for item in array {
            let annotation = StudentLocationAnnotation(title: (item.firstName + " " + item.lastName), mediaURL: item.mediaURL,locationName: item.mapString, coordinate: CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude))
            annotations.append(annotation)
        }

        mapView.addAnnotations(annotations)
        activityIndicator.stopAnimating()
    }
    
    private func clearAnnotations() {
        if annotations.count > 0 {
            mapView.removeAnnotations(annotations)
            annotations.removeAll()
        }
    }
    
    private func animateAnnotationsWithAnnotationArray(views: [MKAnnotationView]) {
        magic("views count: \(views.count)")
        for annotation in views {
            let endFrame = annotation.frame
            annotation.frame = CGRectOffset(endFrame, 0, -500)
            let duration = 0.3
            
            UIView.animateWithDuration(duration, animations: {
                annotation.frame = endFrame
            })
        }
        animatedPinsIn = true
    }
}

extension StudentLocationMapContainerView: MKMapViewDelegate {
    
    func mapViewDidFinishRenderingMap(mapView: MKMapView, fullyRendered: Bool) {
        mapRendered = true
        preloadedMapImage.alpha = 0.0
        placeAnnotations(withStudentInformationArray: studentInformationArray)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? StudentLocationAnnotation {
            var pinView: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(MKPinAnnotationView.reuseIdentifier) as? MKPinAnnotationView {
                
                dequeuedView.annotation = annotation
                pinView = dequeuedView
            } else {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: MKPinAnnotationView.reuseIdentifier)
                pinView.canShowCallout = true
                pinView.calloutOffset = CGPoint(x: -5, y: 5)
                pinView.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
            }
        return pinView
        }
        return nil
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let annotation = view.annotation as! StudentLocationAnnotation
        openLinkClosure?(annotation.mediaURL)
    }
    
    func mapView(mapView: MKMapView, didAddAnnotationViews views: [MKAnnotationView]) {
        if !animatedPinsIn {
            animateAnnotationsWithAnnotationArray(views)
        }
        
    }
}























