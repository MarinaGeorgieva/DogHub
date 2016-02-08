//
//  PlaceDirectionsViewController.swift
//  DogHub
//
//  Created by Emil Iliev on 2/8/16.
//  Copyright © 2016 Marina Georgieva. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

@objc class PlaceDirectionsViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
  
    var placeLocation : CLLocation!
    var locationManager: CLLocationManager!
    var previousLocation : CLLocation!
    
    var placeLongitude: NSNumber = 0
    var placeLatitude: NSNumber = 0
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.delegate = self;
        
        // user activated automatic authorization info mode
        let status = CLLocationManager.authorizationStatus()
        if status == .NotDetermined || status == .Denied || status == .AuthorizedWhenInUse {
            // present an alert indicating location authorization required
            // and offer to take the user to Settings for the app via
            // UIApplication -openUrl: and UIApplicationOpenSettingsURLString
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        
        //mapview setup to show user location
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.mapType = MKMapType(rawValue: 0)!
        mapView.userTrackingMode = MKUserTrackingMode(rawValue: 2)!
    }
    
     func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation){
        //drawing path or route covered
        if let oldLocationNew = oldLocation as CLLocation?{
            let oldCoordinates = oldLocationNew.coordinate
            let newCoordinates = newLocation.coordinate
            print(oldLocationNew.coordinate.longitude)
            print(oldLocationNew.coordinate.latitude)
            print(newLocation.coordinate.longitude)
            print(newLocation.coordinate.latitude)
            var area = [oldCoordinates, newCoordinates]
            let polyline = MKPolyline(coordinates: &area, count: area.count)
            mapView.addOverlay(polyline)
            
        }
        
        //calculation for location selection and pointing annotation
        if let previousLocationNew = previousLocation as CLLocation?{
            //case if previous location exists
            if previousLocation.distanceFromLocation(newLocation) > 200 {
                addAnnotationsOnMap(newLocation)
                previousLocation = newLocation
            }
        }
        else{
            //in case previous location doesn't exist
            addAnnotationsOnMap(newLocation)
            previousLocation = newLocation
        }
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer{
        let pr = MKPolylineRenderer(overlay: overlay)
            pr.strokeColor = UIColor.redColor()
            pr.lineWidth = 5
            return pr
    }
    
    func addAnnotationsOnMap(locationToPoint : CLLocation){
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationToPoint.coordinate
        let geoCoder = CLGeocoder ()
        geoCoder.reverseGeocodeLocation(locationToPoint, completionHandler: { (placemarks, error) -> Void in
            if let placemarks = placemarks as [CLPlacemark]! where placemarks.count > 0 {
                let placemark = placemarks[0]
                var addressDictionary = placemark.addressDictionary;
                annotation.title = addressDictionary!["Name"] as? String
                self.mapView.addAnnotation(annotation)
            }
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
