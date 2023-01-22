//
//  ViewController.swift
//  RXSwift
//
//  Created by Lugalu on 11/01/23.
//

import UIKit
import RxCocoa
import RxSwift
import MapKit

class MapsViewController: UIViewController {
    
    let disposeBag: DisposeBag = DisposeBag()
    let map: MKMapView = MKMapView()
    var previousPin: MKPointAnnotation? = nil
    var locationManager: CLLocationManager? = nil
    var previousUserLocation: CLLocationCoordinate2D? = nil
    
    let isMovingSubject: PublishSubject<Bool> = PublishSubject<Bool>()
    let newLocationSubject: PublishSubject<MKUserLocation> = PublishSubject<MKUserLocation>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(map)
        self.askForPermission()
        
        map.delegate = self
        map.translatesAutoresizingMaskIntoConstraints = false
        map.setUserTrackingMode(MKUserTrackingMode.followWithHeading, animated: false)
        map.showsUserLocation = true
        
        let mapConstraints = [
            map.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            map.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            map.topAnchor.constraint(equalTo: self.view.topAnchor),
            map.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(mapConstraints)
        
        
        _ = isMovingSubject.subscribe(onNext: { isMoving in
            //print("changingColor", isMoving, isMoving ? UIColor.red : UIColor.green)
            self.map.tintColor = isMoving ? .red : .green
            
        })
        .disposed(by: disposeBag)
        
        _ = newLocationSubject.subscribe(onNext: { newLocation in
            guard newLocation.coordinate.longitude.rounded() != self.previousUserLocation?.longitude.rounded()
                    ||
                    newLocation.coordinate.latitude.rounded() != self.previousUserLocation?.latitude.rounded()
            else { return }
                        
            if self.previousPin != nil {
                self.map.removeAnnotation(self.previousPin!)
                self.previousPin = nil
            }
            
            self.previousUserLocation = newLocation.coordinate
            let annotation = MKPointAnnotation()
            annotation.coordinate = newLocation.coordinate

            self.previousPin = annotation

            guard let previousPin = self.previousPin else { return }

            self.map.addAnnotation(previousPin)
        })
        .disposed(by: disposeBag)
        
    }
    
    
}



extension MapsViewController: MKMapViewDelegate{
    
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        self.newLocationSubject.onNext(userLocation)
        if let previousUserLocation{
            self.isMovingSubject.onNext(previousUserLocation.latitude.rounded() != userLocation.coordinate.latitude.rounded() || previousUserLocation.longitude.rounded() != userLocation.coordinate.longitude.rounded())
            return
        }
        self.isMovingSubject.onNext(false)
    }
    
    
    
    
}


extension MapsViewController: CLLocationManagerDelegate{
    
    func askForPermission(){
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager!.requestWhenInUseAuthorization()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        
        if status == .authorizedWhenInUse || status == .authorizedAlways{
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self){
                if CLLocationManager.isRangingAvailable() {
                    manager.requestLocation()
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        render(location.coordinate)
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("hum")
    }
    
    func render (_ location: CLLocationCoordinate2D) {
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: location, span: span)
           
        let center = CLLocation(latitude: -15.7801, longitude: -47.9292)
        let regionLimit = MKCoordinateRegion(center: center.coordinate, latitudinalMeters: 50000, longitudinalMeters: 80000)
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 200000)
        previousUserLocation = location
        let annotation = MKPointAnnotation()
        annotation.coordinate = location

        self.previousPin = annotation
        map.addAnnotation(self.previousPin!)
        
//        map.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: regionLimit), animated: false)
        map.setCameraZoomRange(zoomRange, animated: false)
        map.setRegion(region, animated: false)
       }
    
    
    
}
