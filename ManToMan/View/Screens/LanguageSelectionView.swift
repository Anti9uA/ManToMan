//
//  LanguageSelectionView.swift
//  Kyupago
//
//  Created by Kyubo Shim on 2023/01/31.
//

import SwiftUI

struct LanguageSelectionView: View {
    @Binding var langList: [Lang]
    @Binding var currentLang: String
    @Binding var isSheetPresented: Bool
    
    
    var body: some View {
        VStack (alignment: .center){
            
            List{
                Section() {
                    HStack{
                        // 중앙 정렬 Spacer()를 야매로 쓰기 위함
                        Text("")
                        
                        Spacer()
                        
                        Text("상대방은 어떤 언어를 사용하나요?")
                            .font(.customTitle())
                            .padding(EdgeInsets(top: 40, leading: 0, bottom: 18, trailing: 0))
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                    }
                    .listRowInsets(EdgeInsets())
                    
                }
                ForEach(langList, id: \.self) { lang in
                    HStack{
                        // 중앙 정렬 Spacer()를 야매로 쓰기 위함
                        Text("")
                        
                        Spacer()
                        
                        Button(action: {
                            currentLang = NSLocalizedString(lang.key, comment: "")
                            isSheetPresented = false
                        }, label: {
                            Text(NSLocalizedString(lang.key, comment: ""))
                                .padding(.vertical, 18)
                                .font(.customBody())
                                .foregroundColor(currentLang == NSLocalizedString(lang.key, comment: "") ? Color.mainBlue : Color.black)
                        })
                        
                        Spacer()
                    }
                    .listRowInsets(EdgeInsets())
                }
            }
            .listStyle(.inset)
        }
    }
    
    func localizedStringForLocalizedStringKey(_ key: LocalizedStringKey) -> String {
        let keyString = "\(key)"
        return NSLocalizedString(keyString, comment: "")
    }
}
