//
//  Controller.Extension.swift
//  MonBaluchon
//
//  Created by TomF on 28/06/2022.
//

import Foundation
import UIKit

extension UIViewController {
    public func setUpViewElements(element: UIView, borderWidth: CGFloat, borderColor: CGColor, cornerRadius: CGFloat) {
        element.layer.borderWidth = borderWidth
        element.layer.borderColor = borderColor
        element.layer.cornerRadius = cornerRadius
    }
    
    public func presentAlert(with error: String) {
        let alert: UIAlertController = UIAlertController(title: "Erreur", message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
    }
}
