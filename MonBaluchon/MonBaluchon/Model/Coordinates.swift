//
//  Coordinates.swift
//  MonBaluchon
//
//  Created by TomF on 27/07/2022.
//

import Foundation

// MARK: - WelcomeElement
struct Coordinates: Codable {
    let name: String
    let lat, lon: Double

    enum CodingKeys: String, CodingKey {
        case name
        case lat, lon
    }
}
