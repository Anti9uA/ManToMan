//
//  TranslationModel.swift
//  Kyupago
//
//  Created by Kyubo Shim on 2023/01/29.
//

import Foundation

struct TranslatedModel: Codable {
    var result: String = ""
}

struct DefaultStringModel {
    var idle: [String: String]
    var pleaseSpeak: [String: String]
    var pleaseWait: [String: String]
    
    init() {
        self.idle = ["영어" : "Please wait.. ", "일본어" : "待ってください。", "중국어(간체)" : "请等着"]
        self.pleaseSpeak = ["영어" : "Please speak..", "일본어" : "話してください。", "중국어(간체)" : "请说"]
        self.pleaseWait = ["영어" : "Partner speaking..", "일본어" : "相手が言っています。", "중국어(간체)" : "对方正在说话。"]
        
    }
}

struct LangListModel {
    var langList: [String: String]
    
    init() {
        self.langList = ["한글" : "ko-KR", "영어": "en-US", "일본어": "ja-JP", "중국어(간체)": "zh"]
    }
}

struct Endpoint: Codable {
    let endPoint: String
}

