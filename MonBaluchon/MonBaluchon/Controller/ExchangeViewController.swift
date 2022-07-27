//
//  ExchangeViewController.swift
//  MonBaluchon
//
//  Created by TomF on 24/06/2022.
//

import UIKit

class ExchangeViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var containerView: UIStackView!
    @IBOutlet weak var getResultButton: UIButton!
    @IBOutlet weak var firstCurrencyButton: UIButton!
    @IBOutlet weak var secondCurrencyButton: UIButton!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var resultField: UIView!
    
    private var allElements: [UIView] = []
    private var menuSymbols: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpView()
        
        self.getResultButton.titleLabel?.text = ""
        self.amountTextField.clearButtonMode = .always
        self.amountTextField.clearsOnBeginEditing = true
        
        CurrenciesService.shared.getSymbols { [weak self] success, symbols in
            guard let symbols = symbols else {
                return
            }
            symbols.symbols.forEach { symbol in
                self?.menuSymbols.append("\(symbol.key) : \(symbol.value)")
            }
            
            DispatchQueue.main.async {
                self?.firstCurrencyButton.menu = self?.createFilteringMenu()
                self?.secondCurrencyButton.menu = self?.createFilteringMenu()
                self?.activityIndicator.isHidden = true
                self?.containerView.isHidden = false
            }
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        amountTextField.resignFirstResponder()
    }
    
    @IBAction func getConvertionResult(_ sender: Any) {
        amountTextField.resignFirstResponder()
        getResultButton.isEnabled = false
        if let first = firstCurrencyButton.currentTitle?.prefix(3),
           let second = secondCurrencyButton.currentTitle?.prefix(3),
            let amount = amountTextField.text {
            CurrenciesService.shared.convert(from: String(first), to: String(second), amount: amount) { [weak self] success, amountConverted in
                DispatchQueue.main.async {
                    self?.getResultButton.isEnabled = true
                    guard let amount = amountConverted else {
                        return
                    }
                    self?.resultLabel.text = String(format: "%.2f", amount.result)
                }
            }
        }
    }
    
    private func createFilteringMenu() -> UIMenu {
        var menuActions: [UIAction] = []
        let optionsClosure = { (action: UIAction) in
            print(action.title)
        }
        
        for key in menuSymbols.sorted(by: { $0 < $1 }) {
            let item = UIAction(title: "\(key)", handler: optionsClosure)
            menuActions.append(item)
            print(key)
        }
        
        return UIMenu(title: "Select a currency", children: menuActions)
    }
    
    private func presentAlert(with error: String) {
        let alert: UIAlertController = UIAlertController(title: "Erreur", message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    private func groupAllElements() {
        allElements.append(firstCurrencyButton)
        allElements.append(secondCurrencyButton)
        allElements.append(amountTextField)
        allElements.append(resultField)
    }
    
    private func setUpView() {
        self.groupAllElements()
        allElements.forEach { element in
            setUpViewElements(element: element, borderWidth: 1, borderColor: CGColor.appText, cornerRadius: 5)
        }
    }
}
