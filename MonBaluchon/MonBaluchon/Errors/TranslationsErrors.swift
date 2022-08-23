//
//  TranslationsErrors.swift
//  MonBaluchon
//
//  Created by TomF on 23/08/2022.
//

import Foundation

struct TranslationsErrors: Codable {
    let error: TranslationsErrorDetails
}

struct TranslationsErrorDetails: Codable {
    let code: Int
    let message: String
    let status: String
}
