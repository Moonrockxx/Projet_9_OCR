//
//  ExchangeErrors.swift
//  MonBaluchon
//
//  Created by TomF on 23/08/2022.
//

import Foundation

struct ExchangeErrors: Codable {
    let success: Bool
    let error: ExchangeErrorDetails
}

struct ExchangeErrorDetails: Codable {
    let code: Int
    let type, info: String
}
