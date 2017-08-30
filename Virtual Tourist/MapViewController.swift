//
//  MapViewController.swift
//  Virtual Tourist
//
//  Created by Alan Campos on 8/21/17.
//  Copyright © 2017 Alan Campos. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView() {
        configureMapView()
    }
    
    func addAnnotation(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let point = gesture.location(in: mapView)
            let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let pin = view.annotation
        let selectedAnnotationVC = storyboard?.instantiateViewController(withIdentifier: "SelectedAnnotationViewController") as! SelectedAnnotationViewController
        selectedAnnotationVC.selectedPin = pin
        mapView.deselectAnnotation(pin, animated: false)
        navigationController!.pushViewController(selectedAnnotationVC, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView?.animatesDrop = true
        }
        
        return pinView
    }
}

internal extension MapViewController {
    internal func configureMapView() {
        mapView.delegate = self
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(addAnnotation))
        longPress.minimumPressDuration = 1.5
        mapView.addGestureRecognizer(longPress)
    }
    
}

