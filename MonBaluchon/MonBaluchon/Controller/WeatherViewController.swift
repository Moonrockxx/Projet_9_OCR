//
//  WeatherViewController.swift
//  MonBaluchon
//
//  Created by TomF on 29/06/2022.
//

import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet weak var yourCityTextField: UITextField!
    @IBOutlet weak var travelCityTextField: UITextField!
    
    @IBOutlet weak var yourCityResultStackView: UIStackView!
    @IBOutlet weak var yourCityWeatherLabel: UILabel!
    @IBOutlet weak var yourCityTemperatureLabel: UILabel!
    
    @IBOutlet weak var travelDestinationResultStackView: UIStackView!
    @IBOutlet weak var travelDestinationWeatherLabel: UILabel!
    @IBOutlet weak var travelDestinationTempLabel: UILabel!
    
    private var allElements: [UIView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        yourCityTextField.resignFirstResponder()
        travelCityTextField.resignFirstResponder()
    }
    
    @IBAction func getWeather(_ sender: UIButton) {
        if let city = yourCityTextField.text {
            self.weatherForPart(city: city, part: yourCityResultStackView, weatherLabel: yourCityWeatherLabel, tempLabel: yourCityTemperatureLabel)

        }
        if let cityTravel = travelCityTextField.text {
            self.weatherForPart(city: cityTravel, part: travelDestinationResultStackView, weatherLabel: travelDestinationWeatherLabel, tempLabel: travelDestinationTempLabel)
        }
    }
    
    private func weatherForPart(city: String, part: UIStackView, weatherLabel: UILabel, tempLabel: UILabel) {
        WeatherService.shared.getCoordinates(city: city) { success, coordinates in
            if let long = coordinates?.lon,
               let lat = coordinates?.lat {
                WeatherService.shared.getWeather(lat: lat, lon: long) { success, weather in
                    DispatchQueue.main.async {
                        part.isHidden = false
                        weatherLabel.text = weather?.weather.description
                        if let temp = weather?.main.temp {
                            tempLabel.text = String(format: "%.1f", self.toCelsius(temp))
                        }
                    }
                }
            }
        }
    }
    
    private func toCelsius(_ fah: Double) -> Double {
        let convertion = 5.0 / 9.0 * (fah - 32.0)
        return convertion.rounded()
    }
    
    private func groupAllElements() {
        allElements.append(contentsOf: [yourCityTextField, travelCityTextField])
    }
    
    private func setUpView() {
        self.groupAllElements()
        allElements.forEach { element in
            setUpViewElements(element: element, borderWidth: 1, borderColor: CGColor.appText, cornerRadius: 5)
        }
    }
}
