//
//  UIView+Extension.swift
//  MonBaluchon
//
//  Created by TomF on 17/08/2022.
//

import Foundation
import UIKit

extension UIView {
    public func setUpStyle(borderWidth: CGFloat, borderColor: CGColor, cornerRadius: CGFloat) {
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor
        self.layer.cornerRadius = cornerRadius
    }
}
