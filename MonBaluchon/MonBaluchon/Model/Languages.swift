//
//  Languages.swift
//  MonBaluchon
//
//  Created by TomF on 19/07/2022.
//

import Foundation

struct Languages: Decodable {
    let data: DataLanguages
}

extension Languages {
    struct DataLanguages: Decodable {
        let languages: [LanguagesName]
    }
}

extension Languages.DataLanguages {
    struct LanguagesName: Decodable {
        let language: String
        let name: String
    }
}
