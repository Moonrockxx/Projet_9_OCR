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
}
