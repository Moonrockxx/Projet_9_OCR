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
    @IBOutlet weak var resultLoader: UIActivityIndicatorView!
    @IBOutlet weak var resultStackView: UIStackView!
    
    private var allElements: [UIView] = []
    private var menuSymbols: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.firstCurrencyButton.translatesAutoresizingMaskIntoConstraints = false
        self.secondCurrencyButton.translatesAutoresizingMaskIntoConstraints = false
        self.setUpView()
        
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
        self.resultLoader.isHidden = false
        amountTextField.resignFirstResponder()
        getResultButton.isEnabled = false
        if let first = firstCurrencyButton.currentTitle?.prefix(3),
           let second = secondCurrencyButton.currentTitle?.prefix(3),
           let amt = amountTextField.text {
            CurrenciesService.shared.convert(from: String(first), to: String(second), amount: amt) { [weak self] success, amountConverted in
                DispatchQueue.main.async {
                    self?.resultLoader.isHidden = true
                    self?.resultStackView.isHidden = false
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
    
    private func groupAllElements() {
        allElements.append(firstCurrencyButton)
        allElements.append(secondCurrencyButton)
        allElements.append(amountTextField)
        allElements.append(resultField)
    }
    
    private func setUpView() {
        self.groupAllElements()
        allElements.forEach { element in
            element.setUpStyle(borderWidth: 1, borderColor: CGColor.appText, cornerRadius: 5)
        }
        
        self.amountTextField.clearButtonMode = .always
        self.amountTextField.clearsOnBeginEditing = true
        self.amountTextField.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        
        self.getResultButton.titleLabel?.text = ""
    }
}
