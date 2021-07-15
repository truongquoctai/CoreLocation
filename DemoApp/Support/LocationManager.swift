//
//  LocationManager.swift
//  DemoApp
//
//  Created by truong.quoc.tai on 12/06/2021.
//

import UIKit
import CoreLocation

typealias LocationCompletion = (CLLocation) -> ()

final class LocationManager: NSObject {
    
    //MARK: - Singleton
    static let shared = LocationManager()
    
    //MARK: - Properties
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    private var currentLocationCompletion: LocationCompletion?
    private var locationCompletion: LocationCompletion?
    private var isUpdatingLocation = false
    
    private var didChangeAuthorizationCallback: ((CLAuthorizationStatus) ->Void)?
    public func setOnDidChangeAuthorization(completion: @escaping((CLAuthorizationStatus) ->Void)) {
        didChangeAuthorizationCallback = completion
    }
    
    override init() {
        super.init()
        configLocation()
    }
    
    func configLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100
//        locationManager.allowsBackgroundLocationUpdates = true
    }
    
    func getAuthorizationStatus() -> CLAuthorizationStatus {
        if #available(iOS 14.0, *) {
            return locationManager.authorizationStatus
        } else {
            return CLLocationManager.authorizationStatus()
        }
    }
    
    func request() {
        let status = getAuthorizationStatus()
        
        if status == .denied || status == .restricted || !CLLocationManager.locationServicesEnabled() {
            if let didChangeAuthorizationCallback = didChangeAuthorizationCallback {
                didChangeAuthorizationCallback(status)
            }
            return
        }
        
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        if status == .authorizedWhenInUse {
            locationManager.requestAlwaysAuthorization()
            return
        }
        
        locationManager.requestLocation()
    }
    
    func getCurrentLocation() -> CLLocation? {
        let status = getAuthorizationStatus()
        if status == .denied || status == .restricted || status == .notDetermined || !CLLocationManager.locationServicesEnabled() {
            showAlertGotoSettings()
            return nil
        }
        
        return currentLocation
    }
    
    func startUpdatingLocation(completion: @escaping LocationCompletion) {
        locationCompletion = completion
        isUpdatingLocation = true
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        isUpdatingLocation = false
        locationManager.stopUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if let didChangeAuthorizationCallback = didChangeAuthorizationCallback, status != .notDetermined {
            didChangeAuthorizationCallback(status)
        }
        switch status {
        case .authorizedAlways:
            print("user allow app to get location data when app is active or in background")
            manager.requestLocation()
            
        case .authorizedWhenInUse:
            print("user allow app to get location data only when app is active")
            manager.requestLocation()
            
        case .denied:
            print("user tap 'disallow' on the permission dialog, cant get location data")
            
        case .restricted:
            print("parental control setting disallow location data")
            
        case .notDetermined:
            print("the location permission dialog haven't shown before, user haven't tap allow/disallow")
            
        default:
            print("default")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.currentLocation = location
            
            if let currentCompletion = currentLocationCompletion {
                currentCompletion(location)
            }
            
            if isUpdatingLocation, let updating = locationCompletion {
                updating(location)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
}

//MARK: - Other
extension LocationManager {
    func getLocation(from address: String, completion: @escaping (_ location: CLLocationCoordinate2D?)-> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            guard let placemarks = placemarks,
                  let location = placemarks.first?.location?.coordinate else {
                completion(nil)
                return
            }
            completion(location)
        }
    }
    
    func getAddressFromLocation(latitude: Double, longitude: Double, completion: @escaping((String?, Error?) -> Void)) {
        var center = CLLocationCoordinate2D()
        
        let geocoder = CLGeocoder()
        center.latitude = latitude
        center.longitude = longitude
        
        let loc = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
        geocoder.reverseGeocodeLocation(loc, completionHandler: {(placemarks, error) in
            if (error != nil) {
                completion(nil, error)
            } else if let pm = placemarks, pm.count > 0 {
                let pm = placemarks![0]
                
                var addressString = ""
                if pm.subThoroughfare != nil {
                    addressString = addressString + pm.subThoroughfare! + " "
                }
                
                if pm.thoroughfare != nil {
                    addressString = addressString + pm.thoroughfare! + ", "
                }
                
                if pm.subLocality != nil {
                    addressString = addressString + pm.subLocality! + ", "
                }
                
                if pm.subAdministrativeArea != nil {
                    addressString = addressString + pm.subAdministrativeArea! + ", "
                }
                
                if pm.locality != nil {
                    addressString = addressString + pm.locality! + ", "
                }
                
                if pm.country != nil {
                    addressString = addressString + pm.country! + ", "
                }
                
                if pm.postalCode != nil {
                    addressString = addressString + pm.postalCode! + " "
                }
                completion(addressString, nil)
            }
        })
    }
    
    func showAlertGotoSettings() {}
//    {
//        let keyWindow = UIApplication.shared.connectedScenes
//            .filter({$0.activationState == .foregroundActive})
//            .map({$0 as? UIWindowScene})
//            .compactMap({$0})
//            .first?.windows
//            .filter({$0.isKeyWindow}).first
//
//        if var topController = keyWindow?.rootViewController {
//            while let presentedViewController = topController.presentedViewController {
//                topController = presentedViewController
//            }
//            let message = "Ứng dụng không có quyền sử dụng định vị.\nVui lòng cấp quyền cho ứng dụng ở cài đặt để có thể sử dụng."
//            let alertController = UIAlertController (title: "", message: message, preferredStyle: .alert)
//            let settingsAction = UIAlertAction(title: "Đi tới cài đặt", style: .default) { (_) -> Void in
//
//                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
//                    return
//                }
//
//                if UIApplication.shared.canOpenURL(settingsUrl) {
//                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
//                        print("Settings opened: \(success)") // Prints true
//                    })
//                }
//            }
//            alertController.addAction(settingsAction)
//            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
//            alertController.addAction(cancelAction)
//
//            topController.present(alertController, animated: true, completion: nil)
//        }
//    }
}
