//
//  LocationManager.swift
//  Glam360
//
//  Created by cbl16 on 6/28/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import Foundation
import UIKit
import CoreLocation
import PermissionScope

struct Location : CustomStringConvertible {
    var current_lat : String?
    var current_lng : String?
    var current_formattedAddr : String?
    var current_city : String?
    
    var description: String{
        return ""
//        return UtilityFunctions.appendOptionalStrings(withArray: [current_formattedAddr])
    }
}

class LocationManager: NSObject ,  CLLocationManagerDelegate  {
    
    class var sharedInstance: LocationManager {
        struct Static {
            static var instance: LocationManager?
            static var token: dispatch_once_t = 0
        }
        dispatch_once(&Static.token) {
            Static.instance = LocationManager()
        }
        return Static.instance!
    }
    
    var currentLocation : Location? = Location()
    let locationManager = CLLocationManager()
    let pscope = PermissionScope()
    
    func startTrackingUser(){
        // For use in foreground
//        pscope.permissionButtonBorderColor = Colors.PurpleColor.color()
        pscope.closeButtonTextColor = UIColor.blackColor()
//        pscope.permissionButtonTextColor = Colors.PurpleColor.color()
        
        
        pscope.addPermission(LocationWhileInUsePermission(),
                             message: "We use this to track\r\nwhere you live")
        
        // Show dialog with callbacks
        
        pscope.show({ finished, results in
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = 100
            self.locationManager.startUpdatingLocation()
            }, cancelled: { (results) -> Void in
                print("thing was cancelled")
        })
        
    
    }
    
}

extension LocationManager{
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if status == CLAuthorizationStatus.AuthorizedWhenInUse || status == CLAuthorizationStatus.AuthorizedAlways {
            locationManager.startUpdatingLocation()
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error.localizedDescription)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let firstLocation = locations.first else{return}
        CLGeocoder().reverseGeocodeLocation(firstLocation) {[unowned self] (placemarks, error) in
            self.currentLocation?.current_lat = "\(firstLocation.coordinate.latitude)"
            self.currentLocation?.current_lng = "\(firstLocation.coordinate.longitude)"
            guard let bestPlacemark = placemarks?.first else{return}
            self.currentLocation?.current_city = bestPlacemark.locality
//            self.currentLocation?.current_formattedAddr = UtilityFunctions.appendOptionalStrings(withArray: [bestPlacemark.subThoroughfare , bestPlacemark.thoroughfare , bestPlacemark.locality , bestPlacemark.country])
            self.locationManager.stopUpdatingLocation()
            self.locationManager.delegate = nil
        
        }
        
    }

}
