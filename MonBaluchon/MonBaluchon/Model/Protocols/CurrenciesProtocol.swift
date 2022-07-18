//
//  CurrenciesProtocol.swift
//  MonBaluchon
//
//  Created by TomF on 18/07/2022.
//

import Foundation

protocol ConvertDelegate {
    func convert(from: String, to: String, amount: String, callback: @escaping (Bool, Convertion?) -> Void)
}
