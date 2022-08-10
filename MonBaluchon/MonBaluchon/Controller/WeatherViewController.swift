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
        
    @IBOutlet weak var yourCityWeatherResultStackView: UIStackView!
    @IBOutlet weak var yourCityWeatherResultLoader: UIActivityIndicatorView!
    @IBOutlet weak var yourCityWeatherResultButtonStackView: UIStackView!
    @IBOutlet weak var yourCityWeatherResultName: UIButton!
    @IBOutlet weak var yourCityWeatherResultWeather: UIButton!
    @IBOutlet weak var yourCityWeatherResultTemp: UIButton!
    
    @IBOutlet weak var travelDestinationWeatherResultStackView: UIStackView!
    @IBOutlet weak var travelDestinationWeatherResultLoader: UIActivityIndicatorView!
    @IBOutlet weak var travelDestinationWeatherResultButtonStackView: UIStackView!
    @IBOutlet weak var travelDestinationWeatherResultName: UIButton!
    @IBOutlet weak var travelDestinationWeatherResultWeather: UIButton!
    @IBOutlet weak var travelDestinationWeatherResultTemp: UIButton!
    
    private var allElements: [UIView] = []
    
    private var weatherService: WeatherService = WeatherService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        yourCityTextField.resignFirstResponder()
        travelCityTextField.resignFirstResponder()
    }
    
    @IBAction func getWeather(_ sender: UIButton) {
        self.yourCityWeatherResultStackView.isHidden = false
        self.yourCityWeatherResultButtonStackView.isHidden = true
        self.yourCityWeatherResultLoader.isHidden = false
        
        self.travelDestinationWeatherResultStackView.isHidden = false
        self.travelDestinationWeatherResultButtonStackView.isHidden = true
        self.travelDestinationWeatherResultLoader.isHidden = false
        
        if let yourCity = yourCityTextField.text {
            self.weatherService.getWeather(city: yourCity) { [weak self] result in
                switch result {
                case .success(let weather):
                    DispatchQueue.main.async {
                        self?.yourCityWeatherResultLoader.isHidden = true
                        self?.yourCityWeatherResultButtonStackView.isHidden = false
                        self?.yourCityWeatherResultName.titleLabel?.text = self?.yourCityTextField.text
                        self?.yourCityWeatherResultTemp.titleLabel?.text = "\(self?.toCelsius(weather.main.temp) ?? 0)°C"
                        self?.yourCityWeatherResultWeather.titleLabel?.text = weather.weather.first?.weatherDescription.capitalized
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.yourCityWeatherResultStackView.isHidden = true
                        self?.presentAlert(with: "Your city : \(error.description)")
                    }
                }
            }
        }
        if let travelCity = travelCityTextField.text {
            self.weatherService.getWeather(city: travelCity) { [weak self] result in
                switch result {
                case .success(let weather):
                    DispatchQueue.main.async {
                        self?.travelDestinationWeatherResultLoader.isHidden = true
                        self?.travelDestinationWeatherResultButtonStackView.isHidden = false
                        self?.travelDestinationWeatherResultName.titleLabel?.text = self?.travelCityTextField.text
                        self?.travelDestinationWeatherResultTemp.titleLabel?.text = "\(self?.toCelsius(weather.main.temp) ?? 0)°C"
                        self?.travelDestinationWeatherResultWeather.titleLabel?.text = weather.weather.first?.weatherDescription.capitalized
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.hideAllResults()
                        self?.presentAlert(with: "Your travel destination : \(error.description)")
                    }
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
    
    private func hideAllResults() {
        self.yourCityWeatherResultStackView.isHidden = true
        self.travelDestinationWeatherResultStackView.isHidden = true
    }
}
