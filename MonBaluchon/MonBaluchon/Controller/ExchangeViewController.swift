//
//  ExchangeViewController.swift
//  MonBaluchon
//
//  Created by TomF on 24/06/2022.
//

import UIKit

class ExchangeViewController: UIViewController {
    
    let screenWidth = UIScreen.main.bounds.width - 10
    let screenHeight = UIScreen.main.bounds.height / 4
    
    var topPickerSelectedRow = 0
    var bottomPickerSelectedRow = 0
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var containerView: UIStackView!
    @IBOutlet weak var getResultButton: UIButton!
    
    @IBOutlet weak var topCurrencyButton: UIButton!
    @IBOutlet weak var bottomCurrencyButton: UIButton!
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var resultField: UIView!
    @IBOutlet weak var resultLoader: UIActivityIndicatorView!
    @IBOutlet weak var resultStackView: UIStackView!
    
    private var allElements: [UIView] = []
    private var menuSymbols: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        
        CurrenciesService.shared.getSymbols { [weak self] success, symbols in
            guard let symbols = symbols else {
                return
            }
            
            symbols.symbols.forEach { symbol in
                self?.menuSymbols.append("\(symbol.key) : \(symbol.value)")
                let sortedMenu = self?.menuSymbols.sorted(by: { $0 < $1 })
                self?.menuSymbols = sortedMenu ?? []
            }
            
            if success {
                DispatchQueue.main.async {
                    self?.activityIndicator.isHidden = true
                    self?.containerView.isHidden = false
                }
            } else {
                DispatchQueue.main.async {
                    self?.presentAlert(with: "Can't get the symbols list")
                }
            }
        }
    }

    @IBAction func showTopButtonPopUp(_ sender: Any) {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)
        let topPickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        topPickerView.dataSource = self
        topPickerView.delegate = self
        topPickerView.selectRow(self.topPickerSelectedRow, inComponent: 0, animated: false)
        
        vc.view.addSubview(topPickerView)
        topPickerView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        topPickerView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
        
        let alert = UIAlertController(title: "Select a currency", message: "", preferredStyle: .actionSheet)
        alert.popoverPresentationController?.sourceView = topCurrencyButton
        alert.popoverPresentationController?.sourceRect = topCurrencyButton.bounds
        
        alert.setValue(vc, forKey: "contentViewController")
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            
        }))
        
        alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { _ in
            self.topPickerSelectedRow = topPickerView.selectedRow(inComponent: 0)
            let selected = Array(self.menuSymbols)[self.topPickerSelectedRow]
            let currency = selected
            self.topCurrencyButton.setTitle(currency, for: .normal)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func showBottomButtonPopUp(_ sender: Any) {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)
        
        let bottomPickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        bottomPickerView.dataSource = self
        bottomPickerView.delegate = self
        bottomPickerView.selectRow(bottomPickerSelectedRow, inComponent: 0, animated: false)
        
        vc.view.addSubview(bottomPickerView)
        
        bottomPickerView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        bottomPickerView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
        
        let alert = UIAlertController(title: "Select a target currency", message: "", preferredStyle: .actionSheet)
        alert.popoverPresentationController?.sourceView = bottomCurrencyButton
        alert.popoverPresentationController?.sourceRect = bottomCurrencyButton.bounds
        alert.setValue(vc, forKey: "contentViewController")
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            
        }))
        
        alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { _ in
            self.bottomPickerSelectedRow = bottomPickerView.selectedRow(inComponent: 0)
            let selected = Array(self.menuSymbols)[self.bottomPickerSelectedRow]
            let currency = selected
            self.bottomCurrencyButton.setTitle(currency, for: .normal)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        amountTextField.resignFirstResponder()
    }
    
    @IBAction func getConvertionResult(_ sender: Any) {
        self.resultLoader.isHidden = false
        amountTextField.resignFirstResponder()
        getResultButton.isEnabled = false
        if let first = topCurrencyButton.currentTitle?.prefix(3),
           let second = bottomCurrencyButton.currentTitle?.prefix(3),
           let amt = amountTextField.text {
            CurrenciesService.shared.convert(from: String(first), to: String(second), amount: amt) { [weak self] success, amountConverted in
                if success {
                    DispatchQueue.main.async {
                        self?.resultLoader.isHidden = true
                        self?.resultStackView.isHidden = false
                        self?.getResultButton.isEnabled = true
                        guard let amount = amountConverted else {
                            return
                        }
                        self?.resultLabel.text = String(format: "%.2f", amount.result)
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.presentAlert(with: "Can't make the convertion")
                        self?.resultLoader.isHidden = true
                        self?.resultStackView.isHidden = true
                        self?.getResultButton.isEnabled = true
                    }
                }
            }
        }
    }
    
    private func groupAllElements() {
        allElements.append(topCurrencyButton)
        allElements.append(bottomCurrencyButton)
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

extension ExchangeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        menuSymbols.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 30))
        label.text = Array(menuSymbols)[row]
        label.sizeToFit()
        return label
    }
}
