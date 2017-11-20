//
//  MapViewController.swift
//  ScripturesMapped
//
//  Created by Victor Lazaro on 10/30/17.
//  Copyright © 2017 Victor Lazaro. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    // MARK: - Constants
    var defaultTitle = "Scripture Map"
    
    
    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Members
    var geoPlaces: [GeoPlace]?
    var singleGeoPlace: GeoPlace?
    
    // MARK: - View Controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        
        mapView.removeAnnotations(mapView.annotations)

        if singleGeoPlace == nil {
            if let places = geoPlaces {
                if places.count > 0 {
                    setMapRegion()
                    title = defaultTitle
                }
            }
        }

        if let place = singleGeoPlace {
            mapView.addAnnotation(getAnnotation(geoPlace: place))
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let place = singleGeoPlace {
            title = place.placename
            centerOnGeoPlace(place)
        }

    }

    
    // MARK: - Map helpers
    
    private func getAnnotation(geoPlace : GeoPlace) -> MKPointAnnotation {
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = CLLocationCoordinate2DMake(geoPlace.latitude, geoPlace.longitude)
        annotation.title = geoPlace.placename
        
        return annotation
    }
    
    
    
    private func setMapRegion() {
        if let places = geoPlaces {
            var annotations: [MKAnnotation] = []
            for geoplace in places {
                
                let annotation = getAnnotation(geoPlace: geoplace)
                
                annotations.append(annotation)
                mapView.addAnnotation(annotation)
            }
            mapView.setRegion(regionForAnnotations(annotations: annotations), animated: true)
        }
    }
    
    public func centerOnGeoPlace(_ geoPlace : GeoPlace) {
        let camera = MKMapCamera(lookingAtCenter: CLLocationCoordinate2DMake(geoPlace.latitude, geoPlace.longitude), fromEyeCoordinate: CLLocationCoordinate2DMake((geoPlace.viewLatitude)! - 0.01, (geoPlace.viewLongitude)!), eyeAltitude: (geoPlace.viewAltitude)!)
        mapView.setCamera(camera, animated: true)
    }
    
    private func getGeoPlaceByName(_ title : String) -> GeoPlace {
        guard let places = geoPlaces else {
            return singleGeoPlace!
        }
        
        for place in places {
            if place.placename == title {
                return place
            }
        }
        return singleGeoPlace!
    }

    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        singleGeoPlace = getGeoPlaceByName(((view.annotation?.title)!)!)
        self.title = (view.annotation?.title) ?? defaultTitle
        centerOnGeoPlace(singleGeoPlace!)
    }
    
    /*
    * Extracted this function from https://gist.github.com/robmooney/923301
    */
    private func regionForAnnotations(annotations : [MKAnnotation]) -> MKCoordinateRegion {
        
        var minLat: CLLocationDegrees = 90.0
        var maxLat: CLLocationDegrees = -90.0
        var minLon: CLLocationDegrees = 180.0
        var maxLon: CLLocationDegrees = -180.0
        
        for annotation in annotations as [MKAnnotation] {
            let lat = Double(annotation.coordinate.latitude)
            let long = Double(annotation.coordinate.longitude)
            if (lat < minLat) {
                minLat = lat
            }
            if (long < minLon) {
                minLon = long
            }
            if (lat > maxLat) {
                maxLat = lat
            }
            if (long > maxLon) {
                maxLon = long
            }
        }
        
        let span = MKCoordinateSpanMake(maxLat - minLat, maxLon - minLon)
        
        let center = CLLocationCoordinate2DMake((maxLat - span.latitudeDelta / 2), maxLon - span.longitudeDelta / 2)
        
        return MKCoordinateRegionMake(center, span)
    }
    
    // MARK: - Map view delegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier = "Pin"
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        if view == nil {
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            pinView.canShowCallout = true
            pinView.animatesDrop = true
            pinView.pinTintColor = UIColor.purple
            view = pinView
        }
        else {
            view?.annotation = annotation
        }
        return view
    }

}
