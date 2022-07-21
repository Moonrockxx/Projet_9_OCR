//
//  Translation.swift
//  MonBaluchon
//
//  Created by TomF on 20/07/2022.
//

import Foundation

struct Translations: Decodable {
    let data: DataTranslations
}

extension Translations {
    struct DataTranslations: Decodable {
        let translations: [TranslationResult]
    }
}

extension Translations.DataTranslations {
    struct TranslationResult: Decodable {
        let translatedText: String
    }
}
