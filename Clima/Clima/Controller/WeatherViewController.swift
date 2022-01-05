//
//  ViewController.swift
//  Clima
//
//  Created by sky on 1/1/22.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ask permission to get access user's location. it will show popup alert to user
        // add 1 line in plist file -> App Category -> Privacy - Location When In Use Usage Description
        
        // locationManager delegate has to assign to self BEFORE requestWhenInUseAuthorization. Otherwise, app will crash
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        // when we call requestLocation, the func didUpdateLocations in extension will be triggered
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        searchTextField.delegate = self
        
    }
    
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        // khi minh call requestLocation func, the func didUpdateLocations in extension will be triggered
        locationManager.requestLocation()
    }
    
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
    }
    
    // this func will be executed when user tap enter or tap on simulator return keyboard. We
    // have this func when we conform UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(searchTextField.text!)
        searchTextField.endEditing(true)
        return true
    }
    
    // when user finish editing the textField. it will work for both searchPressed and textFiledShouldReturn.
    // instead of reset text into empty string in both funcs above, we reset it here to avoid repeat code
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
        searchTextField.placeholder = "Search"
    }
    
    
    // this func will validate text in textField. If it returns true, the func textFieldDidEndEditing will be triggered
    // if it returns false, the func textFieldDidEndEditing will not be triggered
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
}

// MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print(error.localizedDescription)
    }
}

// MARK: - CCLocationManagerDelegate
// when we implement CLLocationManagerDelegate, we have to implement 2 func, didUpdateLocations va didFailWithError

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // locations has an array of lots of locations -> choose the last one would be the most accurate one
        if let location = locations.last {
            // when we already get location, we need to stop updating location
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
        print("Got location data")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
