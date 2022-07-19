//
//  TranslationHelperViewController.swift
//  MonBaluchon
//
//  Created by TomF on 28/06/2022.
//

import UIKit

class TranslationHelperViewController: UIViewController, UITextViewDelegate {

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
        
        LanguagesService.shared.getLanguages { [weak self] success, languages in
            guard let languages = languages else {
                return
            }
            
            languages.lang?.forEach { key, value in
                self?.menuLanguages.append(String(describing: value))
            }
            
            self?.firstLanguagePicker.menu = self?.createFilteringMenu()
            self?.secondLanguagePicker.menu = self?.createFilteringMenu()
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
        
        for key in menuLanguages {
            let item = UIAction(title: "\(value(forKey: key) ?? "")", handler: optionsClosure)
            menuActions.append(item)
            print(value(forKey: key) ?? "")
        }
        
        return UIMenu(title: "Select a currency", children: menuActions)
    }
}
