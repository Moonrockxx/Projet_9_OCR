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
    
    private var weatherService: WeatherService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        yourCityTextField.resignFirstResponder()
        travelCityTextField.resignFirstResponder()
    }
    
    @IBAction func getWeather(_ sender: UIButton) {
        if let yourCity = yourCityTextField.text {
            self.weatherService?.getWeather(city: yourCity) { [weak self] result in
                switch result {
                case .success(let weather):
                    DispatchQueue.main.async {
                        self?.yourCityTemperatureLabel.text = "\(self?.toCelsius(weather.main.temp) ?? 0)°C"
                        self?.yourCityWeatherLabel.text = weather.weather.first?.weatherDescription.capitalized
                        self?.yourCityResultStackView.isHidden = false
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.presentAlert(with: error.description)
                    }
                }
            }
        }
        if let travelCity = travelCityTextField.text {
            self.weatherService?.getWeather(city: travelCity) { [weak self] result in
                switch result {
                case .success(let weather):
                    DispatchQueue.main.async {
                        self?.travelDestinationTempLabel.text = "\(self?.toCelsius(weather.main.temp) ?? 0)°C"
                        self?.travelDestinationWeatherLabel.text = weather.weather.first?.weatherDescription.capitalized
                        self?.travelDestinationResultStackView.isHidden = false
                    }
                case .failure(let error):
                    self?.presentAlert(with: error.description)
                }
            }
        }
    }
    
    private func toCelsius(_ kel: Double) -> Int {
        let convertion = kel - 273.15
        return Int(convertion.rounded())
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
