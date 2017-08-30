//
//  SelectedAnnotationViewController.swift
//  Virtual Tourist
//
//  Created by Alan Campos on 8/27/17.
//  Copyright © 2017 Alan Campos. All rights reserved.
//

import UIKit
import MapKit

class SelectedAnnotationViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    let flickrConnection = ConnectionHandler.shared.instance
    let reuseCell = "collectionViewCell"
    
    var selectedPin: MKAnnotation!
    var photoURLS: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        configureView()
        getPhotosForSelectedLocation()
    }
    
    private func getPhotosForSelectedLocation() {
        let urlParts = [
            URLSegment.host : Flickr.URL.host,
            URLSegment.scheme : Flickr.URL.scheme,
            URLSegment.path : Flickr.URL.path
        ]
        
        let queries = [
            Flickr.key.api : Flickr.value.api,
            "method" : "flickr.photos.search",
            "format" : "json",
            "extras" : "url_m",
            "bbox" : bboxString(),
            "nojsoncallback" : "1"
        ]
        
        flickrConnection.urlSegments = urlParts
        flickrConnection.query = queries
        flickrConnection.getFlickrPhoto {
            photos, success, error in
            
            if success {
                var photoURLArray = [String]()
                for photo in photos! {
                    photoURLArray.append(photo.url)
                }
                self.photoURLS = photoURLArray
                performUIUpdatesOnMain {
                    self.collectionView.reloadData()
                }
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if photoURLS != nil {
            return photoURLS.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCell, for: indexPath) as! SelectedAnnotationCollectionViewCell
        let activityIndicator = UIActivityIndicatorView(frame: cell.imageView.frame)
        activityIndicator.backgroundColor = .black
        cell.addSubview(activityIndicator)
        activityIndicator.startAnimating()
            let photo = photoURLS[indexPath.row]
            cell.imageView.downloadedFrom(link: photo) {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            }
        return cell
    }
    
    private func bboxString() -> String {
        if selectedPin != nil {
            let latitude = selectedPin.coordinate.latitude
            let longitude = selectedPin.coordinate.longitude
            let minimumLon = max(longitude - Flickr.Query.SearchBBoxHalfWidth, Flickr.Query.SearchLonRange.0)
            let minimumLat = max(latitude - Flickr.Query.SearchBBoxHalfHeight, Flickr.Query.SearchLatRange.0)
            let maximumLon = min(longitude + Flickr.Query.SearchBBoxHalfWidth, Flickr.Query.SearchLonRange.1)
            let maximumLat = min(latitude + Flickr.Query.SearchBBoxHalfHeight, Flickr.Query.SearchLatRange.1)
            return "\(minimumLon),\(minimumLat),\(maximumLon),\(maximumLat)"
        } else {
            return "0,0,0,0"
        }
    }
}

internal extension SelectedAnnotationViewController {
    
    internal func configureView() {
        configureMapView()
    }
    
    internal func configureMapView() {
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        let region = MKCoordinateRegion(center: selectedPin.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        mapView.addAnnotation(selectedPin)
    }

}
