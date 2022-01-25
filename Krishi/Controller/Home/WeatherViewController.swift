//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//


    var weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        weatherManager.fetchWeatherData(city: "userdefaults")
        weatherManager.delegate = self
    }
    
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController : WeatherManagerDelegate{
    
    func didUpdateWeather(_ weatherManager : WeatherManager ,weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.cityLabel.text = weather.cityName
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
        }
    }

    func didFailWithError(_ error: Error) {
        print(error)
    }
}
