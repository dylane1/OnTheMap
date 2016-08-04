//
//  MapContainerViewController.swift
//  On The Map
//
//  Created by Dylan Edwards on 7/11/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit
import MapKit

class MapContainerViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    private var locationName    = "foo"
    private var latitude        = 0.0
    private var longitude       = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate    = self
        mapView.mapType     = .Standard
        
        prettyIt()
        configureLabelWithString(locationName)
        showLocationOnMap(withLatitude: latitude, longitude: longitude)
    }
    
    //MARK: - Configuration
    
    internal func configure(withLocationName name: String, latitude lat: Double, longitude lon: Double) {
        locationName    = name
        latitude        = lat
        longitude       = lon
    }

    private func prettyIt() {
        view.layer.cornerRadius     = 6
        view.layer.shadowColor      = UIColor.blackColor().CGColor
        view.layer.shadowOpacity    = 0.6
        view.layer.shadowRadius     = 10
        view.layer.shadowOffset     = CGSize(width: 5, height: 5)
        view.layer.masksToBounds    = false
    }
    
    private func configureLabelWithString(name: String) {
        locationLabel.text = name
    }
    
    private func showLocationOnMap(withLatitude latitude: Double, longitude: Double) {
        let coordinate          = CLLocationCoordinate2DMake(latitude, longitude)
        let regionRadius        = CLLocationDistance(54000)
        let coordinateRegion    = MKCoordinateRegionMakeWithDistance(coordinate, regionRadius * 2.0, regionRadius * 2.0)
        
        mapView.setRegion(coordinateRegion, animated: true)
        
        let annotation          = MKPointAnnotation()
        annotation.coordinate   = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        mapView.addAnnotation(annotation)
    }

}

extension MapContainerViewController {
    func mapViewDidFinishRenderingMap(mapView: MKMapView, fullyRendered: Bool) {
        /**
         Some areas fully render only on simulator! Many locations are failing
         to render on the device but work fine on simulator... WTF????
         
         Could it be a memory and/or cache issue???
        */
    }
}
