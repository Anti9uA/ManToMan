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
    @AppStorage("mikeInstruction") var mikeInstruction: Bool = true
    @AppStorage("currenLocale") var currentLocale: String = Locale.current.language.languageCode!.identifier as String
    @StateObject private var mv = MainViewModel()
    @StateObject private var lv = LanguageViewModel()
    @State var isSheetPresented: Bool = false
    @State var isRecentPresented: Bool = false
    @State var isTranslatedReversed = true
    @State var isRecordButtonToggled = false
    @State var placeholderLine: CGFloat = 5
    @State var recentOpacity = 0.0
    @State var recentDelay = 0.5
    @State var isSpeechAuth = false
    private var defaultLang: [String: String] = ["ko": "한글", "en" : "영어", "ja": "일본어"]
    
    init() {
        print(currentLocale)
    }
    var body: some View {
        GeometryReader { geo in
            VStack{
                ZStack(alignment: .top) {
                    
                    // MARK: 배경화면
                    
                    Color("background")
                        .edgesIgnoringSafeArea(.top)
                    
                    VStack (alignment: .center){
                        
                        // MARK: 언어 변경 메뉴
                        
                        Button(action: {
                            self.isSheetPresented.toggle()
                        }, label: {
                            HStack {
                                Text("\(lv.currentLang)")
                                    .font(.customTitle())
                                    .foregroundColor(.black)
                                
                                Image(systemName: "chevron.down")
                                    .fontWeight(.bold)
                            }
                        })
                        .sheet(isPresented: $isSheetPresented) {
                            LanguageSelectionView(langList: $mv.langList, currentLang: $lv.currentLang, isSheetPresented: $isSheetPresented)
                                .presentationDetents([.medium, .large])
                                .onDisappear{
                                    ManToManAPI.instance.postData(text: mv.debouncedText, selectedlang: mv.mainViewState == .mikePassed ? defaultLang[currentLocale] ?? "한글" : lv.currentLang)
                                }
                        }
                        
                        
                        // MARK: 번역 결과 창
                        
                        ZStack(alignment: .topLeading){
                            Rectangle()
                                .frame(width: geo.size.width - 40, height: 220)
                                .foregroundColor(Color.white)
                                .cornerRadius(30)
                            
                            switch mv.mainViewState {
                                case .idle, .mikeOwned:
                                    if let translated = mv.translated?.result {
                                        Text(translated.isEmpty ? mv.defaultString.idle[lv.currentLang]! : translated)
                                            .font(.english())
                                            .frame(width: geo.size.width - 80, height: 190, alignment: .topLeading)
                                            .background(.white)
                                            .minimumScaleFactor(0.8)
                                            .foregroundColor(translated.isEmpty ? Color.disabledPurple : Color.mainPurple)
                                            .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20))
                                        
                                    }
                                    
                                    else {
                                        Text(mv.defaultString.idle[lv.currentLang]!)
                                            .font(.korean())
                                            .frame(width: geo.size.width - 80, height: 190, alignment: .topLeading)
                                            .background(.white)
                                            .foregroundColor(Color.disabledPurple)
                                            .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20))
                                    }
                                    
                                case .mikePassed:
                                    ZStack{
                                        HStack{
                                            if mv.text.isEmpty {
                                                Image("head")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 38)
                                            }
                                            Text(mv.text.isEmpty ? mv.defaultString.pleaseSpeak[lv.currentLang]! : mv.text)
                                            //                                        .font(.english())
                                            //                                        .rotationEffect(Angle(degrees: isTranslatedReversed ? 0 : 180))
                                            //                                        .frame(width: geo.size.width - 80, height: 190, alignment: .topLeading)
                                            //                                        .padding()
                                            //                                        .background(.white)
                                            //                                        .foregroundColor(Color.mainBlue)
                                                .font(.english())
                                                .cornerRadius(20)
//                                                .frame(width: geo.size.width - 80, height: 190, alignment: .topLeading)
//                                                .background(.white)
//                                                .minimumScaleFactor(0.8)
                                                .foregroundColor(Color.mainPurple)
//                                                .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20))
//                                                .overlay(
//                                                    RoundedRectangle(cornerRadius: 20)
//                                                        .stroke(Color.mainPurple, lineWidth: 2.5)
//                                                )
                                                .onChange(of: mv.debouncedText) { newValue in
                                                    ManToManAPI.instance.postData(text: newValue, selectedlang: mv.mainViewState == .mikePassed ? defaultLang[currentLocale] ?? "한글" : lv.currentLang)
                                                }
                                        }
                                    }
                                    .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20))
                                    .frame(width: geo.size.width - 40, height: 220, alignment: .topLeading)
                                    .background(.white)
                                    .minimumScaleFactor(0.8)
                                    .cornerRadius(20)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.mainPurple, lineWidth: 2.5)
                                    )
                                    
                            }
                            
                        }
                        .rotationEffect(Angle(degrees: isTranslatedReversed ? 180 : 0))
                        
                        
                        ZStack{
                            
                            // MARK: 한글 입력 텍스트 필드
                            switch mv.mainViewState {
                                case .idle:
                                    TextField("", text: $mv.text, axis: .vertical)
                                        .font(.korean())
                                        .foregroundColor(.mainBlue)
                                        .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 40))
                                        .frame(width: geo.size.width - 40)
                                        .placeholder(when: mv.text.isEmpty) {
                                            HStack{
                                                Image("head")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 38)
                                                Text("한국어를 입력하세요.")
                                                    .font(.korean())
                                                    .foregroundColor(.disabledBlue)
                                            }
                                            .padding(20)
                                            .lineLimit(...7)
                                        }
                                    // .multilineTextAlignment(.leading)
                                        .background(.white)
                                        .submitLabel(.done)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.mainBlue, lineWidth: 5)
                                        )
                                        .cornerRadius(20)
                                        .onChange(of: mv.debouncedText) { newValue in
                                            ManToManAPI.instance.postData(text: newValue, selectedlang: mv.mainViewState == .mikePassed ? defaultLang[currentLocale] ?? "한글" : lv.currentLang)
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
                                                placeholderLine = 200
                                            }
                                        }
                                    
                                case .mikeOwned:
                                    ZStack{
                                        HStack{
                                            if mv.text.isEmpty{
                                                Image("head")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 38)
                                            }
                                            Text(mv.text.isEmpty ? NSLocalizedString("user_speaking", comment: "") : mv.text)
                                                .font(.korean())
                                                .foregroundColor(mv.text.isEmpty ? .disabledBlack : .black)
                                            
                                                .multilineTextAlignment(.center)
                                                .onChange(of: mv.debouncedText) { newValue in
                                                    ManToManAPI.instance.postData(text: newValue, selectedlang: mv.mainViewState == .mikePassed ? defaultLang[currentLocale] ?? "한글" : lv.currentLang)
                                                }
                                            Spacer()
                                        }
                                    }
                                    .frame(width: geo.size.width - 80)
                                    .padding(20)
                                    //                                    .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                                    .background(.white)
                                    .cornerRadius(20)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.mainBlue, lineWidth: 2.5)
                                    )
                                    
                                case .mikePassed:
                                    let translated = mv.translated?.result ?? NSLocalizedString("partner_speaking", comment: "")
                                        
                                        Text(translated.isEmpty ? NSLocalizedString("partner_speaking", comment: "") : translated)
                                            .font(.korean())
                                            .foregroundColor(translated.isEmpty || mv.translated?.result == nil ? .disabledBlack : .black)
                                            .frame(width: geo.size.width - 80)
                                            .padding(20)
                                        //                                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 15, trailing: 20))
                                            .multilineTextAlignment(.center)
                                            .background(.white)
                                            .cornerRadius(20)
                                    
                                    
                            }
                            
                            // MARK: 입력 일괄 삭제 버튼
                            //                        if !mv.text.isEmpty && !mv.audioEngine.isRunning  {
                            //                                Button(action: {
                            //                                    DispatchQueue.main.async {
                            //                                        mv.text = ""
                            //                                        mv.translated?.result = ""
                            //                                        // flipSpeaker = false
                            //                                        mv.mainViewState = .idle
                            //                                    }
                            //                                }, label: {
                            //                                    Image(systemName: "x.circle.fill")
                            //                                        .foregroundColor(Color.mainBlue)
                            //                                })
                            //                        }
                            
                            if !mv.text.isEmpty && !mv.getAudioEngine(key: "myAudioEngine").isRunning && !mv.getAudioEngine(key: "myAudioEngine").isRunning  {
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        DispatchQueue.main.async {
                                            mv.text = ""
                                            mv.translated?.result = ""
                                            // flipSpeaker = false
                                            mv.mainViewState = .idle
                                        }
                                    }, label: {
                                        Image(systemName: "x.circle.fill")
                                            .foregroundColor(Color.mainBlue)
                                    })
                                }
                                .padding(.trailing, 35)
                            }
                        }
                        .padding(.top, 20)
//                        .frame(width: geo.size.width - 100)
                        
                        // MARK: 최근 기록 열람 메뉴
                        // Spacer()
                        
                        //                    ScrollView (.vertical){
                        //                        ZStack{
                        //                            VStack{
                        //                                ForEach(recent, id: \.self){ sen in
                        //                                    ZStack{
                        //                                        Button(action: {
                        //                                            mv.text = sen.sentence ?? "error"
                        //                                        }, label: {
                        //                                            Text(sen.sentence ?? "error")
                        //                                                .lineLimit(1)
                        //                                                .font(.customTitle())
                        //                                                .foregroundColor(.customDarkGray)
                        //                                                .opacity(recentOpacity)
                        //
                        //                                        })
                        //                                        .frame(width: geo.size.width - 100)
                        //
                        //                                        HStack{
                        //                                            Spacer()
                        //                                            Button(action: {
                        //                                                withAnimation {
                        //                                                    self.managedObjContext.delete(sen)
                        //                                                    DataController().save(context: managedObjContext)
                        //                                                }
                        //                                            }, label: {
                        //                                                Image(systemName: "x.circle.fill")
                        //                                                    .foregroundColor(Color.customDarkGray)
                        //                                                    .opacity(recentOpacity)
                        //                                            })
                        //                                        }
                        //                                        .padding(.horizontal, 25)
                        //                                    }
                        //                                    .padding(.bottom, 20)
                        //
                        //                                }
                        //                                Rectangle()
                        //                                    .fill(Color.background)
                        //                                    .frame(height: 10)
                        //                                    .padding(.top, 20)
                        //                            }
                        //                            if !mv.text.isEmpty || mv.text == "\n" || mv.mainViewState != .idle {
                        //                                Color.background
                        //                            }
                        //                        }
                        //                    }
                        //                    .onAppear {
                        //                        withAnimation(.easeIn(duration: 0.9).delay(recentDelay)) {
                        //                            recentOpacity = 1.0
                        //                        }
                        //                    }
                        //                    .overlay(
                        //                        Image("gradientBox")
                        //                            .resizable()
                        //                            .aspectRatio(contentMode: .fill)
                        //                            .frame(width: geo.size.width, height: 50),
                        //                        alignment: .bottom
                        //                    )
                        
                        //                    if mikeInstruction {
                        //                        Text("마이크를 당겨 상대방 대화도 번역해보세요!")
                        //                            .font(.customCaption())
                        //                            .foregroundColor(.mainBlue)
                        //                            .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                        //                            .background(Color.white)
                        //                            .cornerRadius(30)
                        //                            .offset(y: 70)
                        //                            .opacity(recentOpacity)
                        //                            .onAppear {
                        //                                withAnimation(.easeIn(duration: 0.9).delay(recentDelay)) {
                        //                                    recentOpacity = 1.0
                        //                                }
                        //                            }
                        //
                        //                    }
                        Spacer()
                        
                        ZStack(alignment: .center) {
                            // MARK: 녹음 시작 버튼
                            VStack {
                                HStack{
                                    
                                    LottieView(filename: "userSpeakingMotion", lastTime: .infinity)
                                        .frame(width: 60, height: 20)
                                        .opacity(mv.mainViewState != .mikeOwned ? 0 : 1)
                                        .padding(.trailing, 33)
                                    
                                    LottieView(filename: "partnerSpeakingMotion", lastTime: .infinity)
                                        .frame(width: 60, height: 20)
                                        .opacity(mv.mainViewState != .mikePassed ? 0 : 1)
                                        .padding(.leading, 36)
//                                    if mv.mainViewState == .mikePassed {
//                                        LottieView(filename: "speaking", lastTime: .infinity)
//                                            .frame(width: 60, height: 20)
//                                    }
                                }
                                HStack{
                                    
                                    
                                    MyVoiceButtonView(mainViewState: $mv.mainViewState, buttonTappedState: $mv.buttonTappedState, text: $mv.text, isFirst: $mikeInstruction, isSpeechAuth: $isSpeechAuth , startRecord: {
                                        mv.startRecording(selectedLang: mv.mainViewState == .mikePassed ? lv.currentLang : defaultLang[currentLocale] ?? "한글", for: "myAudioEngine")
                                    }, finishRecord: {
                                        mv.stopRecording(for: "myAudioEngine")
                                    })
                                    .padding(.trailing, 40)
                                    
                                    
                                    
                                    
                                    PartnerVoiceRecordView(mainViewState: $mv.mainViewState, buttonTappedState: $mv.buttonTappedState, text: $mv.text, isFirst: $mikeInstruction, isSpeechAuth: $isSpeechAuth, startRecord: {
                                        mv.startRecording(selectedLang: mv.mainViewState == .mikePassed ? lv.currentLang : defaultLang[currentLocale] ?? "한글", for: "partnerAudioEngine")
                                    }, finishRecord: {
                                        mv.stopRecording(for: "partnerAudioEngine")
                                        
                                    })
                                    
                                    
                                    
                                    //                                MyVoiceButtonView(mainViewState: $mv.mainViewState, buttonTappedState: $mv.buttonTappedState, text: $mv.text, isFirst: $mikeInstruction, isSpeechAuth: $isSpeechAuth , startRecord: {
                                    //                                    if mv.audioEngine.isRunning {
                                    //                                        mv.audioEngine.stop()
                                    //                                        mv.audioEngine.inputNode.removeTap(onBus: 0)
                                    //                                        mv.recognitionRequest = nil
                                    //                                        mv.recognitionTask = nil
                                    //                                    }
                                    //                                    mv.startRecording(selectedLang: mv.mainViewState == .mikePassed ? lv.currentLang : defaultLang[currentLocale] ?? "한글")
                                    //                                }, finishRecord: {
                                    //                                    mv.audioEngine.inputNode.removeTap(onBus: 0)
                                    //                                    mv.recognitionRequest?.endAudio()
                                    //                                    mv.audioEngine.stop()
                                    //                                    mv.recognitionRequest = nil
                                    //                                    mv.recognitionTask = nil
                                    //                                })
                                    
                                    //                                SampleButtonView(mainViewState: $mv.mainViewState, buttonTappedState: $mv.buttonTappedState, text: $mv.text, isFirst: $mikeInstruction, isSpeechAuth: $isSpeechAuth , startRecord: {
                                    //                                        mv.startRecording(selectedLang: mv.mainViewState == .mikePassed ? lv.currentLang : defaultLang[currentLocale] ?? "한글")
                                    //                                    }, finishRecord: {
                                    //                                        mv.audioEngine.stop()
                                    //                                        mv.recognitionRequest?.endAudio()
                                    //                                    })
                                    
                                    //                                PartnerVoiceRecordView(mainViewState: $mv.mainViewState, buttonTappedState: $mv.buttonTappedState, text: $mv.text, isFirst: $mikeInstruction, isSpeechAuth: $isSpeechAuth, startRecord: {
                                    //                                    mv.startRecording(selectedLang: mv.mainViewState == .mikePassed ? lv.currentLang : defaultLang[currentLocale] ?? "한글")
                                    //                                }, finishRecord: {
                                    //                                    mv.audioEngine.stop()
                                    //                                    mv.audioEngine.inputNode.removeTap(onBus: 0)
                                    //                                    mv.recognitionRequest?.endAudio()
                                    //                                    mv.recognitionRequest = nil
                                    //                                    mv.recognitionTask = nil
                                    //                                })
                                }
                            }
                            //                            RecordButtonView(mainViewState: $mv.mainViewState, text: $mv.text, isFirst: $mikeInstruction, isSpeechAuth: $isSpeechAuth, startRecord: {
                            //                                mv.startRecording(selectedLang: mv.mainViewState == .mikePassed ? lv.currentLang : defaultLang[currentLocale] ?? "한글")
                            //                            }, finishRecord: {
                            //                                mv.audioEngine.stop()
                            //                                mv.recognitionRequest?.endAudio()
                            //                            })
                            //                            .frame(height: 230)     // 하단 가리개가 가릴시 높이 미세 조정
                            
                            
                            // MARK: UI 반전 토글 버튼
                            
//                            VStack{
//                                Spacer()
//                                HStack{
//                                    Spacer()
//                                    Button(action: {
//                                        self.isTranslatedReversed.toggle()
//
//                                    }, label: {
//                                        Image(isTranslatedReversed ? "meSpeaks" : "youSpeaks")
//                                            .resizable()
//                                            .aspectRatio(contentMode: .fit)
//                                            .frame(width: 67, height: 67)
//                                    })
//                                }
//                                .padding(.trailing, 40)
//                                .padding(.bottom, 10)
//
//                            }
                            
                            
                        }
                        .frame(height: 130)
                        .padding(.vertical, 30)   // 가리개 깨질시 미세 조정
                    }
                    .padding(.top, geo.safeAreaInsets.top)
                }
                .cornerRadius(12)
                
                VStack{
                    Text("번역기록")
                        .font(.customTitle())
                        .padding(EdgeInsets(top: 20, leading: 0, bottom: geo.safeAreaInsets.bottom + 7, trailing: 0))
                }
                .frame(width: geo.size.width)
                .background(.background)
                .cornerRadius(12)
                .onTapGesture {
                    self.isRecentPresented.toggle()
                }
                .sheet(isPresented: $isRecentPresented) {
                    RecentRecordView(isRecentPresented: $isRecentPresented, text: $mv.text)
                        .presentationDetents([.large])
                        .presentationDragIndicator(.visible)
                }
            }
            .ignoresSafeArea()
            .background(Color.customLightGray)
            
            
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}



struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
