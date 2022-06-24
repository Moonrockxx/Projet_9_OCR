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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getResultButton.titleLabel?.text = ""
    }
}
