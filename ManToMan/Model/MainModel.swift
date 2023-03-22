//
//  TranslationModel.swift
//  Kyupago
//
//  Created by Kyubo Shim on 2023/01/29.
//

import Foundation
import SwiftUI

enum MainViewState {
    case idle
    case mikeOwned
    case mikePassed
}

struct TranslatedModel: Codable {
    var result: String = ""
}

struct DefaultStringModel {
    var idle: [String: String]
    var pleaseSpeak: [String: String]
    var pleaseWait: [String: String]

    init() {
        self.idle = ["영어" : "Please wait.. ", "일본어" : "待ってください。", "중국어(간체)" : "请等着",
                     "Korean" : "기다려주세요.. ", "Japanese" : "待ってください。", "Chinese" : "请等着",
                     "韓国語" : "기다려주세요..", "英語" : "Please wait..", "中国語" : "请等着"]
        self.pleaseSpeak = ["영어" : "Please speak..", "일본어" : "話してください。", "중국어(간체)" : "请说",
                            "Korean" : "말씀해주세요.. ", "Japanese" : "話してください。", "Chinese" : "请说",
                            "韓国語" : "말씀해주세요..", "英語" : "Please speak.", "中国語" : "请说"]
        self.pleaseWait = ["영어" : "Partner speaking..", "일본어" : "相手が言っています。", "중국어(간체)" : "对方正在说话。",
                           "Korean" : "상대가 말하고 있어요.. ", "Japanese" : "相手が言っています。", "Chinese" : "对方正在说话。",
                           "韓国語" : "상대가 말하고 있어요..", "英語" : "Partner speaking..", "中国語" : "对方正在说话。"]
    }
}

struct LangListModel {
    var langList: [String: String]
    
    init() {
        self.langList = ["한글" : "ko-KR", "영어": "en-US", "일본어": "ja-JP", "중국어(간체)": "zh",
                         "Korean" : "ko-KR", "English" : "en-US", "Chinese" : "zh", "Japanese": "ja-JP",
                         "韓国語" : "ko-KR", "英語" : "en-US", "中国語" : "zh", "日本語" : "ja-JP"]
    }
}

struct Lang: Identifiable, Hashable {
    let id: UUID
    let key: String
    let displayName: String

    init(key: String, displayName: String) {
        self.id = UUID()
        self.key = key
        self.displayName = displayName
    }
}

struct Endpoint: Codable {
    let endPoint: String
}

