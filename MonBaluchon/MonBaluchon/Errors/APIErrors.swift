//
//  APIErrors.swift
//  MonBaluchon
//
//  Created by TomF on 08/08/2022.
//

import Foundation

public enum APIErrors: Error {
    case badURL
    case badResquest
    case dataParsing
    
    var description: String {
        switch self {
        case .badURL:
            return "Bad URL used to perform this action"
        case .badResquest:
            return "The city cannot be found"
        case .dataParsing:
            return "Can't fetch datas"
        }
    }
}
