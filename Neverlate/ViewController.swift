//
//  ViewController.swift
//  Neverlate
//
//  Created by Hannes Sandberg on 2015-04-18.
//  Copyright (c) 2015 Hannes Sandberg. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    //MKUserLocation userLocation = self.mapView.userLocation
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        //self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        
        self.locationManager.startUpdatingLocation()
        
        zoomIn()
        
        
    }

    func zoomIn(){

        var span = MKCoordinateSpanMake(0.03, 0.03)

        var userLocation: CLLocationCoordinate2D = locationManager.location.coordinate

        var region = MKCoordinateRegion(center: userLocation, span: span)
        
        mapView.setRegion(region, animated:true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func longPressed(sender: UIGestureRecognizer) {
        if(sender.state == UIGestureRecognizerState.Changed || sender.state == UIGestureRecognizerState.Ended){
            return
        }
        mapView.removeAnnotations(mapView.annotations)
        var point = sender.locationInView(mapView)
        let locCoordinate = mapView.convertPoint(point, toCoordinateFromView: mapView)
        //var annotation = MKAnnotation()
        //create an MKPointAnnotation object
        let annotation = MKPointAnnotation()
        annotation.coordinate = locCoordinate
        mapView.addAnnotation(annotation)
        
        //show route between current location and pin
        let request = MKDirectionsRequest()
        let source = MKMapItem.mapItemForCurrentLocation()
        let destination = MKMapItem(placemark: MKPlacemark(coordinate: locCoordinate, addressDictionary: NSDictionary(dictionary: [" ":" "]) as [NSObject : AnyObject]))
        request.setSource(source)
        request.setDestination(destination)
        request.requestsAlternateRoutes = false
        request.transportType = MKDirectionsTransportType.Walking
        let directions = MKDirections(request: request)
        
        directions.calculateDirectionsWithCompletionHandler({(response:
            MKDirectionsResponse!, error: NSError!) in
            
            if error != nil {
                // Handle error
            } else {
                self.showRoute(response)
            }
            
        })
//        for overlay in mapView.overlays as! [MKOverlay]{
//            mapView.rendererForOverlay(overlay)
//        }

        }
    
    
    func showRoute(response: MKDirectionsResponse) {
        for route in response.routes as! [MKRoute] {
            
            mapView.addOverlay(route.polyline, level:MKOverlayLevel.AboveRoads)
            
            
//            mapView.addOverlay(route.polyline,
//                level: MKOverlayLevel.AboveRoads)
            
            for step in route.steps {
                println(step.instructions)
    }
    }
//    let userLocation = routeMap.userLocation
//    let region = MKCoordinateRegionMakeWithDistance(
//    userLocation.location.coordinate, 2000, 2000)
//    
//    routeMap.setRegion(region, animated: true)
    }
//    func mapView(mapView: MKMapView!, rendererForOverlay
//        overlay: MKOverlay!) -> MKOverlayRenderer! {
//            let renderer = MKPolylineRenderer(overlay: overlay)
//            
//            renderer.strokeColor = UIColor.blueColor()
//            renderer.lineWidth = 5.0
//            return renderer
//    }
}

