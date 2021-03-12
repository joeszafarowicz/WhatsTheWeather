//
//  ViewController.swift
//  WhatsTheWeather
//
//  Created by Joseph Szafarowicz on 3/12/21.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        fetchOpenWeatherData(latitude: manager.location?.coordinate.latitude ?? 37.3230, longitude: manager.location?.coordinate.longitude ?? -122.0322)
        
        DispatchQueue.main.async {
            self.summaryLabel.text = "Currently \(currentCondition.lowercased()) and \(currentSummary.lowercased())."
            self.currentTemperatureLabel.text = "Temperature: \(currentTemperature)°"
            self.feelsLikeLabel.text = "Feels like: \(feelsLikeTemperature)°"
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}

