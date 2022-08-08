//
//  TranslationHelperViewController.swift
//  MonBaluchon
//
//  Created by TomF on 28/06/2022.
//

import UIKit

class TranslationHelperViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var containerView: UIStackView!
    @IBOutlet weak var firstLanguagePicker: UIButton!
    @IBOutlet weak var secondLanguagePicker: UIButton!
    @IBOutlet weak var textfieldForTranslate: UITextView!
    @IBOutlet weak var translatedTextfield: UITextView!
    @IBOutlet weak var getTranslationButton: UIButton!
    
    private var allElements: [UIView] = []
    private var menuLanguages: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        textfieldForTranslate.delegate = self
        
        LanguagesService.shared.getLanguages { [weak self] result in
            switch result {
            case .success(let languages):
                languages.data.languages.forEach { lang in
                    self?.menuLanguages.append("\(lang.language): \(lang.name)")
                }
                
                DispatchQueue.main.async {
                    self?.firstLanguagePicker.menu = self?.createFilteringMenu()
                    self?.secondLanguagePicker.menu = self?.createFilteringMenu()
                    self?.loader.isHidden = true
                    self?.containerView.isHidden = false
                }
            case .failure(let error):
                self?.presentAlert(with: error.description)
            }
        }
    }
    
    @IBAction func translateText(_ sender: Any) {
        getTranslationButton.isEnabled = false
        if let from = firstLanguagePicker.currentTitle?.prefix(2),
           let to = secondLanguagePicker.currentTitle?.prefix(2),
           let text = textfieldForTranslate.text {
            LanguagesService.shared.getTranslation(from: String(from), to: String(to), text: text) { [weak self] result in
                switch result {
                case .success(let text):
                    DispatchQueue.main.async {
                        self?.getTranslationButton.isEnabled = true
                        self?.translatedTextfield.text = text.data.translations.first?.translatedText
                    }
                case .failure(let error):
                    self?.presentAlert(with: error.description)
                }
            }
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textfieldForTranslate.resignFirstResponder()
        translatedTextfield.resignFirstResponder()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textfieldForTranslate.text = String()
    }
    
    private func groupAllElements() {
        allElements.append(firstLanguagePicker)
        allElements.append(secondLanguagePicker)
        allElements.append(textfieldForTranslate)
        allElements.append(translatedTextfield)
    }
    
    private func setUpView() {
        self.groupAllElements()
        allElements.forEach { element in
            setUpViewElements(element: element, borderWidth: 1, borderColor: CGColor.appText, cornerRadius: 5)
        }
        
        textfieldForTranslate.contentInset.left = 8
        translatedTextfield.contentInset.left = 8
    }
    
    private func createFilteringMenu() -> UIMenu {
        var menuActions: [UIAction] = []
        let optionsClosure = { (action: UIAction) in
            print(action.title)
        }
        
        for languageName in menuLanguages.sorted(by: { $0 < $1 }) {
            if languageName != "" {
                let item = UIAction(title: languageName, handler: optionsClosure)
                menuActions.append(item)
            }
        }
        
        return UIMenu(title: "Select a language", children: menuActions)
    }
}
