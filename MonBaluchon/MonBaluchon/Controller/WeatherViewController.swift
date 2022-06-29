//
//  WeatherViewController.swift
//  MonBaluchon
//
//  Created by TomF on 29/06/2022.
//

import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet weak var yourCityPicker: UIButton!
    @IBOutlet weak var travelDestinationPicker: UIButton!
    @IBOutlet weak var displayWeatherStackView: UIStackView!
    @IBOutlet weak var yourCityName: UILabel!
    @IBOutlet weak var yourCityWeather: UIImageView!
    @IBOutlet weak var yourCityTemperature: UILabel!
    @IBOutlet weak var travelCityName: UILabel!
    @IBOutlet weak var travelCityWeather: UIImageView!
    @IBOutlet weak var travelCityTemperature: UILabel!
    
    private var allElements: [UIView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    
    @IBAction func getWeather(_ sender: UIButton) {
        // TODO: Call to api
        // TODO: Animation
        self.displayWeatherStackView.isHidden = false
    }
    
    private func groupAllElements() {
        allElements.append(yourCityPicker)
        allElements.append(travelDestinationPicker)
    }
    
    private func setUpView() {
        self.groupAllElements()
        allElements.forEach { element in
            setUpViewElements(element: element, borderWidth: 1, borderColor: CGColor.appText, cornerRadius: 5)
        }
    }
}
