//
//  WeatherViewController.swift
//  Clima
//
//  Created by Tran Thanh Bang on 2018/05/09.
//  Copyright © 2018年 Tran Thanh Bang. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
    
    // MARK: ---- INIT
    
    let API_KEY : String = "b6907d289e10d714a6e88b30761fae22"
    let API_URL : String = "http://samples.openweathermap.org/data/2.5/weather"
    
    let locationManager = CLLocationManager()
    let weatherModel = WeatherModelObject()
    @IBOutlet weak var tempoLabel: UILabel!
    @IBOutlet weak var tempoIconImageView: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: ---- SETUP LOCATION MANAGER
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: ---- NETWORK
    
    func getWeatherData(url : String, andParam params :[String : String]){
        Alamofire.request(url, method: .get, parameters: params).validate().responseJSON{
            responde in
            if responde.result.isSuccess{
                print("Response successed")
                let weatherJson : JSON = JSON(responde.result.value!)
                print(weatherJson)
                self.updateWeatherData(json: weatherJson)
            }else{
                print("Error \(responde.result.error!)")
            }
        }
    }
    
    // MARK: ---- JSON PARSE
    
    func updateWeatherData(json : JSON){
        let tempResult = json["main"]["temp"].double
        if tempResult != nil {
            weatherModel.temperatue = Int(tempResult! - 273.15)
            weatherModel.city = json["name"].stringValue
            weatherModel.condition = json["weather"][0]["id"].intValue
            weatherModel.weatherIcon = weatherModel .updateWeatherIcon(condition: weatherModel.condition)
            updateUI(weather: weatherModel)
        }
    }
    
    // MARK: ---- UI UPDATE
    
    func updateUI(weather: WeatherModelObject){
        tempoLabel.text = String(format: "%i", weather.temperatue)
        cityNameLabel.text = weather.city
        tempoIconImageView.image = UIImage(named: weather.weatherIcon)
    }
    
    // MARK: ---- CLLOCATION DELEGATE
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        let location = locations[locations.count - 1]
        
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            let params : [String : String] = ["lat" : String(location.coordinate.longitude),
                                              "lon" : String(location.coordinate.latitude),
                                              "appid" : API_KEY]
            getWeatherData(url: API_URL, andParam: params)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityNameLabel.text = "Unavalabel"
    }
    
    
    // MARK: ---- CHANGECITY DELEGATE
    
    func userEnteredNameCity(cityName: String) {
        print(cityName)
        let param : [String : String] = ["q" : cityName]
        getWeatherData(url: API_URL, andParam: param)
    }
    
    // MARK: ---- BUTTON ACTION
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChangeCityName" {
            let destinationVC = segue.destination as! ChangeCtityViewController
            destinationVC.delegate = self;
        }
    }
    
}
