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
        textfieldForTranslate.delegate = self
        
        self.setUpView()
        
        LanguagesService.shared.getLanguages { [weak self] success, languages in
            guard let languages = languages else {
                return
            }
            
            languages.data.languages.forEach { lang in
                self?.menuLanguages.append("\(lang.language): \(lang.name)")
            }
            
            DispatchQueue.main.async {
                self?.firstLanguagePicker.menu = self?.createFilteringMenu()
                self?.secondLanguagePicker.menu = self?.createFilteringMenu()
                self?.loader.isHidden = true
                self?.containerView.isHidden = false
            }
            
        }
    }
    
    @IBAction func translateText(_ sender: Any) {
        getTranslationButton.isEnabled = false
        if let from = firstLanguagePicker.currentTitle?.prefix(2),
           let to = secondLanguagePicker.currentTitle?.prefix(2),
           let txt = textfieldForTranslate.text {
            LanguagesService.shared.getTranslation(from: String(from), to: String(to), text: txt) { [weak self] success, translatedText in
                guard let text = translatedText else {
                    return
                }
                
                DispatchQueue.main.async {
                    self?.getTranslationButton.isEnabled = true
                    self?.translatedTextfield.text = text.data.translations.first?.translatedText
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
        allElements.append(firstLanguagePicker)
        allElements.append(secondLanguagePicker)
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
    
    private func createFilteringMenu() -> UIMenu {
        var menuActions: [UIAction] = []
        let optionsClosure = { (action: UIAction) in
            print(action.title)
        }
        
        for languageName in menuLanguages.sorted(by: { $0 < $1 }) where languageName != "" {
            let item = UIAction(title: languageName, handler: optionsClosure)
            menuActions.append(item)
        }
        
        return UIMenu(title: "Select a language", children: menuActions)
    }
}
