//
//  LocationManager.swift
//  VenueExplorer
//
//  Created by Duc Tran on 9/1/16.
//  Copyright © 2016 Developers Academy. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject
{
    let manager = CLLocationManager()
    var didGetLocation: ((Coordinate) -> Void)?
    
    override init() {
        super.init()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestLocation()
        //manager.startUpdatingLocation()

    }
    
    func getPermission() {
        if CLLocationManager.authorizationStatus() == .notDetermined {
            manager.requestWhenInUseAuthorization()
        }
    }
    func getUpdate(){
            }
}

extension LocationManager : CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        if status == .authorizedWhenInUse {
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        guard let location = locations.first else { return }
        let coordinate = Coordinate(location: location)
        if let didGetLocation = didGetLocation {
            didGetLocation(coordinate)
        }
        print("Update location:",coordinate)
    }
}

private extension Coordinate {
    init(location: CLLocation) {
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
    }
}



















