//
//  FontExtention.swift
//  ManToMan
//
//  Created by 조은비 on 2023/02/05.
//

import Foundation
import SwiftUI

extension Font {
    // 피그마에 사용된 폰트 보시고, 사용하시면 됩니다!
    // font(Font.customTitle()) 이런식으로 사용하시면 돼요!
    
    static func customTitle() -> Font {
        return Font.custom("LINESeedSansKR-Bold", size: 20)
    }
    
    static func customBody() -> Font {
        return Font.custom("LINESeedSansKR-Regular", size: 20)
    }
    
    static func customSubBody() -> Font {
        return Font.custom("LINESeedSansKR-Regular", size: 16)
    }
    
    static func customCaption() -> Font {
        return Font.custom("LINESeedSansKR-Bold", size: 14)
    }
    
    // 번역체 모음
    static func korean() -> Font {
        return Font.custom("LINESeedSansKR-Bold", size: 24)
    }
    
    static func english() -> Font {
        return Font.custom("LINESeedJPApp_OTF-Bold", size: 24)
    }
    
    static func sampleTextFont() -> Font {
        return Font.custom("LINESeedJPApp_OTF-Bold", size: 20)
    }
}
