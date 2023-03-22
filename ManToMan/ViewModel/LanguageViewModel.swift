//
//  LanguageViewModel.swift
//  ManToMan
//
//  Created by Kyubo Shim on 2023/03/22.
//

import Foundation
import SwiftUI

class LanguageViewModel: ObservableObject {
    @AppStorage("selectedLang") var currentLang: String = {
        switch Locale.current.language.languageCode!.identifier as String {
        case "en":
            return Language.english.rawValue
        case "ko":
            return Language.korean.rawValue
        case "ja":
            return Language.japanese.rawValue
        default:
            return Language.korean.rawValue // 기본 언어로 영어를 사용합니다.
        }
    }()
}
