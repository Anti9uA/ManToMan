//
//  LanguageSelectionView.swift
//  Kyupago
//
//  Created by Kyubo Shim on 2023/01/31.
//

import SwiftUI

struct LanguageSelectionView: View {
    @Binding var langList: [String]
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
                            currentLang = lang
                            isSheetPresented = false
                        }, label: {
                            Text(lang)
                                .padding(.vertical, 18)
                                .font(.customeBody())
                                .foregroundColor(lang == currentLang ? Color.mainBlue : Color.black)
                        })
                        
                        Spacer()
                    }
                    .listRowInsets(EdgeInsets())
                }
            }
            .listStyle(.inset)
        }
    }
}

struct LanguageSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        LanguageSelectionView(langList: .constant(["영어", "일본어", "중국어(간체)"]), currentLang: .constant("영어"), isSheetPresented: .constant(true))
    }
}
