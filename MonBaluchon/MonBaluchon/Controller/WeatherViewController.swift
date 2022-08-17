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
            self.weatherService.getWeather(city: yourCity) { [weak self] success, weather in
                if success {
                    DispatchQueue.main.async {
                        if let weather = weather {
                            self?.yourCityWeatherResultLoader.isHidden = true
                            self?.yourCityWeatherResultButtonStackView.isHidden = false
                            self?.yourCityWeatherResultName.titleLabel?.text = self?.yourCityTextField.text
                            self?.yourCityWeatherResultTemp.titleLabel?.text = "\(self?.toCelsius(weather.main.temp) ?? 0)°C"
                            self?.yourCityWeatherResultWeather.titleLabel?.text = weather.weather.first?.weatherDescription.capitalized
                        }
                    }
                } else {
                    self?.hideAllResults()
                }
                
            }
        }
        if let travelCity = travelCityTextField.text {
            self.weatherService.getWeather(city: travelCity) { [weak self] success, weather in
                if success {
                    DispatchQueue.main.async {
                        if let weather = weather {
                            self?.travelDestinationWeatherResultLoader.isHidden = true
                            self?.travelDestinationWeatherResultButtonStackView.isHidden = false
                            self?.travelDestinationWeatherResultName.titleLabel?.text = self?.travelCityTextField.text
                            self?.travelDestinationWeatherResultTemp.titleLabel?.text = "\(self?.toCelsius(weather.main.temp) ?? 0)°C"
                            self?.travelDestinationWeatherResultWeather.titleLabel?.text = weather.weather.first?.weatherDescription.capitalized
                        }
                    }
                } else {
                    self?.hideAllResults()
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
        self.yourCityTextField.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        self.travelCityTextField.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
    }
    
    private func hideAllResults() {
        self.yourCityWeatherResultStackView.isHidden = true
        self.travelDestinationWeatherResultStackView.isHidden = true
    }
}
