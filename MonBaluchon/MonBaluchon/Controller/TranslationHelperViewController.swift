//
//  TranslationHelperViewController.swift
//  MonBaluchon
//
//  Created by TomF on 28/06/2022.
//

import UIKit

class TranslationHelperViewController: UIViewController, UITextViewDelegate {
    
    let screenWidth = UIScreen.main.bounds.width - 10
    let screenHeight = UIScreen.main.bounds.height / 4
    
    var topPickerSelectedRow = 0
    var bottomPickerSelectedRow = 0
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var containerView: UIStackView!
    
    @IBOutlet weak var firstLanguagePicker: UIButton!
    @IBOutlet weak var secondLanguagePicker: UIButton!
    @IBOutlet weak var topLanguagePicker: UIButton!
    @IBOutlet weak var bottomLanguagePicker: UIButton!
    
    @IBOutlet weak var textfieldForTranslate: UITextView!
    @IBOutlet weak var translatedTextfield: UITextView!
    @IBOutlet weak var getTranslationButton: UIButton!
    @IBOutlet weak var translatedTextStackView: UIStackView!
    @IBOutlet weak var resultLoader: UIActivityIndicatorView!
    
    private var allElements: [UIView] = []
    private var menuLanguages: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textfieldForTranslate.delegate = self
        
        self.setUpView()
        
        LanguagesService.shared.getLanguages { [weak self] success, languages in
            guard let languages = languages else {
                return
            }
            
            languages.data.languages.forEach { lang in
                self?.menuLanguages.append("\(lang.language): \(lang.name)")
                let sortedMenu = self?.menuLanguages.sorted(by: { $0 < $1 })
                self?.menuLanguages = sortedMenu ?? []
            }
            
            if success {
                DispatchQueue.main.async {
                    self?.loader.isHidden = true
                    self?.containerView.isHidden = false
                }
            } else {
                DispatchQueue.main.async {
                    self?.presentAlert(with: "Can't get the languages list")
                }
            }
        }
    }
    
    @IBAction func showTopLanguageList(_ sender: Any) {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)
        let topPickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        topPickerView.dataSource = self
        topPickerView.delegate = self
        topPickerView.selectRow(self.topPickerSelectedRow, inComponent: 0, animated: false)
        
        vc.view.addSubview(topPickerView)
        topPickerView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        topPickerView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
        
        let alert = UIAlertController(title: "Select your language", message: "", preferredStyle: .actionSheet)
        alert.popoverPresentationController?.sourceView = topLanguagePicker
        alert.popoverPresentationController?.sourceRect = topLanguagePicker.bounds
        
        alert.setValue(vc, forKey: "contentViewController")
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            
        }))
        
        alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { _ in
            self.topPickerSelectedRow = topPickerView.selectedRow(inComponent: 0)
            let selected = Array(self.menuLanguages)[self.topPickerSelectedRow]
            let currency = selected
            self.topLanguagePicker.setTitle(currency, for: .normal)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func showBottomLanguageList(_ sender: Any) {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)
        
        let bottomPickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        bottomPickerView.dataSource = self
        bottomPickerView.delegate = self
        bottomPickerView.selectRow(bottomPickerSelectedRow, inComponent: 0, animated: false)
        
        vc.view.addSubview(bottomPickerView)
        
        bottomPickerView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        bottomPickerView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
        
        let alert = UIAlertController(title: "Select a target language", message: "", preferredStyle: .actionSheet)
        alert.popoverPresentationController?.sourceView = bottomLanguagePicker
        alert.popoverPresentationController?.sourceRect = bottomLanguagePicker.bounds
        alert.setValue(vc, forKey: "contentViewController")
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            
        }))
        
        alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { _ in
            self.bottomPickerSelectedRow = bottomPickerView.selectedRow(inComponent: 0)
            let selected = Array(self.menuLanguages)[self.bottomPickerSelectedRow]
            let currency = selected
            self.bottomLanguagePicker.setTitle(currency, for: .normal)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func translateText(_ sender: Any) {
        self.resultLoader.isHidden = false
        getTranslationButton.isEnabled = false
        if let from = topLanguagePicker.currentTitle?.prefix(2),
           let to = bottomLanguagePicker.currentTitle?.prefix(2),
           let txt = textfieldForTranslate.text {
            LanguagesService.shared.getTranslation(from: String(from), to: String(to), text: txt) { [weak self] success, translatedText in
                guard let text = translatedText else {
                    return
                }
                
                if success {
                    DispatchQueue.main.async {
                        self?.resultLoader.isHidden = true
                        self?.translatedTextStackView.isHidden = false
                        self?.getTranslationButton.isEnabled = true
                        self?.translatedTextfield.text = text.data.translations.first?.translatedText
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.presentAlert(with: "Can't translate your text")
                    }
                }
            }
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textfieldForTranslate.resignFirstResponder()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textfieldForTranslate.text = String()
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textfieldForTranslate.resignFirstResponder()
        return true
    }
    
    private func groupAllElements() {
        allElements.append(topLanguagePicker)
        allElements.append(bottomLanguagePicker)
        allElements.append(textfieldForTranslate)
        allElements.append(translatedTextfield)
    }
    
    private func setUpView() {
        self.groupAllElements()
        allElements.forEach { element in
            element.setUpStyle(borderWidth: 1, borderColor: CGColor.appText, cornerRadius: 5)
        }
        
        textfieldForTranslate.contentInset.left = 8
        translatedTextfield.contentInset.left = 8
        
        self.textfieldForTranslate.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
    }
    
//    private func createFilteringMenu() -> UIMenu {
//        var menuActions: [UIAction] = []
//        let optionsClosure = { (action: UIAction) in
//            print(action.title)
//        }
//        
//        for languageName in menuLanguages.sorted(by: { $0 < $1 }) where languageName != "" {
//            let item = UIAction(title: languageName, handler: optionsClosure)
//            menuActions.append(item)
//        }
//        
//        return UIMenu(title: "Select a language", children: menuActions)
//    }
}

extension TranslationHelperViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        menuLanguages.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 30))
        label.text = Array(menuLanguages)[row]
        label.sizeToFit()
        return label
    }
}
