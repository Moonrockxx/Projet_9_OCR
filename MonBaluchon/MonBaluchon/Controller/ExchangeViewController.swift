//
//  ExchangeViewController.swift
//  MonBaluchon
//
//  Created by TomF on 24/06/2022.
//

import UIKit

class ExchangeViewController: UIViewController {

    @IBOutlet weak var getResultButton: UIButton!
    @IBOutlet weak var firstCurrencyButton: UIButton!
    @IBOutlet weak var secondCurrencyButton: UIButton!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var resultField: UIView!
    
    private var allElements: [UIView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpView()
        
        self.getResultButton.titleLabel?.text = ""
        self.amountTextField.clearButtonMode = .always
        
        firstCurrencyButton.menu = createFilteringMenu()
        secondCurrencyButton.menu = createFilteringMenu()
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        amountTextField.resignFirstResponder()
    }
    
    @IBAction func getConvertionResult(_ sender: Any) {
        //TODO: Calculte change rate
        self.presentAlert(with: "Calculation of exchange rate not implemented")
    }
    
    private func createFilteringMenu() -> UIMenu {
        var menuActions: [UIAction] = []
        let optionsClosure = { (action: UIAction) in
            // TODO: Use this closure for change rate
            print(action.title)
        }
        
        currency.forEach{ value in
            let item = UIAction(title: "\(value)", handler: optionsClosure)
            menuActions.append(item)
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
