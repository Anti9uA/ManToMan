//
//  MainView.swift
//  Kyupago
//
//  Created by Kyubo Shim on 2023/01/27.
//

import SwiftUI
import Combine
import Speech

struct MainView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var recent: FetchedResults<Recent>
    @AppStorage("selectedLang") var currentLang: String = "영어"
    @AppStorage("mikeInstruction") var isFirst: Bool = true
    @StateObject var mv = MainViewModel()
    @State var isSheetPresented: Bool = false
    @State var langList: [String] = ["영어", "일본어", "중국어(간체)"]
    @State var isConfrontToggled = false
    @State var isRecordButtonToggled = false
    @State var placeholderLine: CGFloat = 5
    @State var recentOpacity = 0.0
    @State var recentDelay = 0.5
    @State var flipSpeaker = false
    @State var isSpeechAuth = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                
                // MARK: 배경화면
                
                Color("background")
                    .ignoresSafeArea()
                
                VStack (alignment: .center){
                    
                    // MARK: 언어 변경 메뉴
                    
                    Button(action: {
                        self.isSheetPresented.toggle()
                    }, label: {
                        HStack {
                            Text("\(currentLang)")
                                .font(.customTitle())
                                .foregroundColor(.black)
                            
                            Image(systemName: "chevron.down")
                                .fontWeight(.bold)
                        }
                    })
                    .sheet(isPresented: $isSheetPresented) {
                        LanguageSelectionView(langList: $langList, currentLang: $currentLang, isSheetPresented: $isSheetPresented)
                            .presentationDetents([.medium, .large])
                            .onDisappear{
                                ManToManAPI.instance.postData(text: mv.debouncedText, selectedlang: flipSpeaker ? "한글" : currentLang)
                            }
                    }
                    
                    
                    // MARK: 번역 결과 창
                    
                    ZStack{
                        Rectangle()
                            .cornerRadius(30)
                            .frame(width: geo.size.width - 40, height: 160)
                            .foregroundColor(Color.white)
                        
                        switch mv.mainViewState {
                            case .idle, .mikeOwned:
                                if let translated = mv.translated?.result {
                                    Text(translated.isEmpty ? mv.defaultString.idle[currentLang]! : translated)
                                        .font(.english())
                                        .rotationEffect(Angle(degrees: isConfrontToggled ? 0 : 180))
                                        .frame(width: geo.size.width - 72)
                                        .padding()
                                        .background(.white)
                                        .foregroundColor(translated.isEmpty ? Color.disabledBlue : Color.mainBlue)
                                        .cornerRadius(30)
                                        .multilineTextAlignment(.center)
                                }
                                
                                else {
                                    Text(mv.defaultString.idle[currentLang]!)
                                        .font(.korean())
                                        .rotationEffect(Angle(degrees: isConfrontToggled ? 0 : 180))
                                        .frame(width: 350)
                                        .background(.white)
                                        .foregroundColor(Color.disabledBlue)
                                        .cornerRadius(30)
                                }
                                
                            case .mikePassed:
                                Text(mv.text.isEmpty ? mv.defaultString.pleaseSpeak[currentLang]! : mv.text)
                                    .font(.english())
                                    .rotationEffect(Angle(degrees: isConfrontToggled ? 0 : 180))
                                    .frame(width: geo.size.width - 72)
                                    .padding()
                                    .background(.white)
                                    .foregroundColor(Color.mainBlue)
                                    .cornerRadius(30)
                                    .multilineTextAlignment(.center)
                                    .onChange(of: mv.debouncedText) { newValue in
                                        ManToManAPI.instance.postData(text: newValue, selectedlang: flipSpeaker ? "한글" : currentLang)
                                    }
                        }
    
                    }
                    .padding(.bottom, 40)
                    
                    ZStack{
                        
                        // MARK: 한글 입력 텍스트 필드
                        switch mv.mainViewState {
                            case .idle:
                                TextField("", text: $mv.text, axis: .vertical)
                                    .placeholder(when: mv.text.isEmpty) {
                                        VStack{
                                            Text("한국어를 입력하세요.")
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
                                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20))
                                    .frame(width: 290)
                                    .multilineTextAlignment(.center)
                                    .submitLabel(.done)
                                    .onChange(of: mv.debouncedText) { newValue in
                                        ManToManAPI.instance.postData(text: newValue, selectedlang: flipSpeaker ? "한글" : currentLang)
                                        if let last = newValue.last, last == "\n" {
                                            mv.text.removeLast()
                                            if !mv.text.isEmpty {
                                                DataController().addRecent(sentence: mv.text, context: managedObjContext)
                                            }
                                            hideKeyboard()
                                        }
                                    }
                                    .onAppear {
                                        withAnimation(.easeInOut(duration: 0.25).delay(0.3)){
                                            placeholderLine = 190
                                        }
                                    }
                            case .mikeOwned:
                                Text(mv.text.isEmpty ? "말해주세요." : mv.text)
                                    .font(.korean())
                                    .frame(width: geo.size.width - 72)
                                    .padding()
                                    .foregroundColor(mv.text.isEmpty ? .disabledBlack : .black)
                                    .multilineTextAlignment(.center)
                                    .onChange(of: mv.debouncedText) { newValue in
                                        ManToManAPI.instance.postData(text: newValue, selectedlang: flipSpeaker ? "한글" : currentLang)
                                    }
                                
                            case .mikePassed:
                                let translated = mv.translated?.result ?? "상대방이 말하고 있어요."
                                Text(translated.isEmpty ? "상대방이 말하고 있어요." : translated)
                                    .font(.korean())
                                    .foregroundColor(translated.isEmpty || mv.translated?.result == nil ? .disabledBlack : .black)
                                    .frame(width: geo.size.width - 72)
                                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
                                    .frame(width: 290)
                                
                        }
                        
                        // MARK: 입력 일괄 삭제 버튼
                        
                        if !mv.text.isEmpty && !mv.audioEngine.isRunning  {
                            HStack {
                                Spacer()
                                Button(action: {
                                    mv.text = ""
                                    // flipSpeaker = false
                                    mv.mainViewState = .idle
                                }, label: {
                                    Image(systemName: "x.circle.fill")
                                        .foregroundColor(Color.mainBlue)
                                })
                            }
                            .padding(.horizontal, 25)
                            .padding(.bottom, 15)
                        }
                    }
                    
                    // MARK: 최근 기록 열람 메뉴
                    
                    ScrollView (.vertical){
                        ZStack{
                            VStack{
                                ForEach(recent, id: \.self){ sen in
                                    ZStack{
                                        Button(action: {
                                            mv.text = sen.sentence ?? "error"
                                        }, label: {
                                            Text(sen.sentence ?? "error")
                                                .lineLimit(1)
                                                .font(.customTitle())
                                                .foregroundColor(.customDarkGray)
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
                                                    .foregroundColor(Color.customDarkGray)
                                                    .opacity(recentOpacity)
                                            })
                                        }
                                        .padding(.horizontal, 25)
                                    }
                                    .padding(.bottom, 20)
                                    
                                }
                                Rectangle()
                                    .fill(Color.background)
                                    .frame(height: 10)
                                    .padding(.top, 20)
                            }
                            if !mv.text.isEmpty || mv.text == "\n" || mv.mainViewState == .mikePassed{
                                Color.background
                            }
                        }
                    }
                    .onAppear {
                        withAnimation(.easeIn(duration: 0.9).delay(recentDelay)) {
                            recentOpacity = 1.0
                        }
                    }
                    .overlay(
                        Image("gradientBox")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 50), alignment: .bottom)
                    if isFirst {
                        Text("마이크를 당겨 상대방 대화도 번역해보세요!")
                            .font(.customCaption())
                            .foregroundColor(.mainBlue)
                            .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                            .background(Color.white)
                            .cornerRadius(30)
                            .offset(y: 70)
                            .opacity(recentOpacity)
                            .onAppear {
                                withAnimation(.easeIn(duration: 0.9).delay(recentDelay)) {
                                    recentOpacity = 1.0
                                }
                            }
                        
                    }
                    
                    ZStack(alignment: .center) {
                        // MARK: 녹음 시작 버튼
                        RecordButtonView(mainViewState: $mv.mainViewState, text: $mv.text, isFirst: $isFirst, isSpeechAuth: $isSpeechAuth, startRecord: {
                            mv.startRecording(selectedLang: mv.mainViewState == .mikePassed ? currentLang : "한글")
                        }, finishRecord: {
                            mv.audioEngine.stop()
                            mv.recognitionRequest?.endAudio()
                        })
                        .frame(height: 230)     // 하단 가리개가 가릴시 높이 미세 조정
                        
                        
                        // MARK: UI 반전 토글 버튼
                        
                        VStack{
                            Spacer()
                            HStack{
                                Spacer()
                                Button(action: {
                                    self.isConfrontToggled.toggle()
                                    
                                }, label: {
                                    Image(isConfrontToggled ? "meSpeaks" : "youSpeaks")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 67, height: 67)
                                })
                            }
                            .padding(.trailing, 40)
                            .padding(.bottom, 10)
                            
                        }
                    }
                    .frame(height: 130)
                    .padding(.bottom, 70)   // 가리개 깨질시 미세 조정
                }
                .padding(.top)
                
                // MARK: 마이크 애니메이션 가리개
                
                VStack {
                    Spacer()
                    Image("roundBottom")
                        .resizable()
                        .frame(width: mv.shouldUseCustomFrame() ? 45 : 63, height: mv.shouldUseCustomFrame() ? 26 : 66)
                    
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
