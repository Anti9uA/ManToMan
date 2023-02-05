//
//  MainView.swift
//  Kyupago
//
//  Created by Kyubo Shim on 2023/01/27.
//

import SwiftUI
import Combine

struct MainView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var recent: FetchedResults<Recent>
    
    @StateObject var mv = MainViewModel()
    @State var isSheetPresented: Bool = false
    @State var langList: [String] = ["영어", "일본어", "중국어(간체)"]
    @State var currentLang: String = "영어"
    @State var isConfrontToggled = false
    @State var isRecordButtonToggled = false
    @State var placeholderLine: CGFloat = 5
    @State var recentOpacity = 0.0
    @State var recentDelay = 0.5
    @State var flipSpeaker = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                
                // MARK: 배경화면
                
                Color("background")
                    .ignoresSafeArea()
                
                VStack (alignment: .center){
                    
                    // MARK: 언어 변경 메뉴
                    
                    HStack{
                        Text("\(currentLang)로 번역")
                            .font(.customTitle())
                        
                        Button(action: {
                            self.isSheetPresented.toggle()
                        }, label: {
                            Image(systemName: "chevron.down")
                                .fontWeight(.bold)
                        })
                        .sheet(isPresented: $isSheetPresented) {
                            LanguageSelectionView(langList: $langList, currentLang: $currentLang, isSheetPresented: $isSheetPresented)
                                .presentationDetents([.medium, .large])
                        }
                    }
                    
                    // MARK: 번역 결과 창
                    
                    ZStack{
                        Rectangle()
                            .cornerRadius(30)
                            .frame(width: geo.size.width - 40, height: 160)
                            .foregroundColor(Color.white)
                        
                        if let translated = mv.translated?.result {
                            Text(translated)
                                .font(.system(size: 24, weight: .semibold))
                                .rotationEffect(Angle(degrees: isConfrontToggled ? 0 : 180))
                                .frame(width: geo.size.width - 72)
                                .padding()
                                .background(.white)
                                .foregroundColor(Color("mainBlue"))
                                .cornerRadius(30)
                        }
                        
                        else {
                            Text("Please wait..")
                                .font(.korean())
                                .rotationEffect(Angle(degrees: isConfrontToggled ? 0 : 180))
                                .frame(width: 350)
                                .background(.white)
                                .foregroundColor(Color("mainBlue"))
                                .cornerRadius(30)
                        }
                        
                    }
                    .padding(.bottom, 40)
                    
                    ZStack{
                        
                        // MARK: 한글 입력 텍스트 필드
                        
                        TextField("", text: $mv.text, axis: .vertical)
                            .placeholder(when: mv.text.isEmpty) {
                                VStack{
                                    Text("한글을 입력하세요.")
                                        .foregroundColor(Color.disabledBlack)
                                        .padding(.top, 25)
                                    
                                    Rectangle()
                                        .fill(.blue)
                                        .cornerRadius(10)
                                        .frame(width: placeholderLine, height: 5)
                                        .padding(.bottom, 1)
                                        .offset(y: -10)
                                    Spacer()
                                }
                                .frame(height: 50)
                            }
                            .font(.korean())
                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
                            .multilineTextAlignment(.center)
                            .submitLabel(.done)
                            .onChange(of: mv.debouncedText) { newValue in
                                ManToManAPI.instance.postData(text: newValue, selectedlang: currentLang)
                                if let last = newValue.last, last == "\n" {
                                    mv.text.removeLast()
                                    DataController().addRecent(sentence: mv.text, context: managedObjContext)
                                }
                            }
                            .onAppear {
                                withAnimation(.easeInOut(duration: 0.25).delay(0.3)){
                                    placeholderLine = 190
                                }
                            }
                        
                        // MARK: 입력 일괄 삭제 버튼
                        
                        if !mv.text.isEmpty{
                            HStack {
                                Spacer()
                                Button(action: {
                                    mv.text = ""
                                }, label: {
                                    Image(systemName: "x.circle.fill")
                                        .foregroundColor(Color.mainBlue)
                                })
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    
                    // MARK: 최근 기록 열람 메뉴
                    
                    ScrollView (.vertical){
                        VStack{
                            ForEach(recent, id: \.self){ sen in
                                ZStack{
                                    Button(action: {
                                        mv.text = sen.sentence ?? "error"
                                    }, label: {
                                        Text(sen.sentence ?? "error")
                                            .font(.system(size: 24, weight: .semibold))
                                            .opacity(recentOpacity)
                                        
                                    })
                                    .frame(width: geo.size.width - 100)
                                    
                                    HStack{
                                        Spacer()
                                        Button(action: {
                                            withAnimation {
                                                self.managedObjContext.delete(sen)
                                                DataController().save(context: managedObjContext)
                                            }
                                        }, label: {
                                            Image(systemName: "x.circle.fill")
                                                .foregroundColor(Color.mainRed)
                                        })
                                    }
                                    .padding(.horizontal, 20)
                                }
                                .padding(.bottom, 20)
                                
                            }
                        }
                        
                    }
                    .onAppear {
                        withAnimation(.easeIn(duration: 0.9).delay(recentDelay)) {
                            recentOpacity = 1.0
                        }
                    }
                    
                    
                    ZStack(alignment: .center) {
                        
                        // MARK: 녹음 시작 버튼
                        
                        RecordButtonView(flipSpeaker: $flipSpeaker,
                                         startRecord: {
                            do {
                                try mv.startRecording()
                            } catch {
                                
                            }
                        }, finishRecord: {
                            mv.audioEngine.stop()
                            mv.recognitionRequest?.endAudio()
                        }
                        )
                        
                        // MARK: UI 반전 토글 버튼
                        
                        VStack{
                            Spacer()
                            HStack{
                                Spacer()
                                Button(action: {
                                    self.isConfrontToggled.toggle()
                                    
                                }, label: {
                                    Image("confront")
                                })
                            }
                            .padding(.trailing, 30)
                            .padding(.bottom, 10)
                        }
                    }
                    .frame(height: 180)
                    .padding(.bottom, 20)
                }
                .padding(.top)
                
                // MARK: 마이크 애니메이션 가리개
                
                VStack{
                    Spacer()
                    Image("roundBottom")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 88, height: 66)
                }
                .ignoresSafeArea()
                
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
