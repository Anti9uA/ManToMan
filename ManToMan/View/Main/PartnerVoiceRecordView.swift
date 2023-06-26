//
//  PartnerVoiceRecordView.swift
//  ManToMan
//
//  Created by Kyubo Shim on 2023/06/10.
//

import SwiftUI
import Speech

struct PartnerVoiceRecordView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @StateObject var rv = RecordViewModel()
    @State private var isAnimationPlaying = true
    @State var isTapped: Bool = false
    @Binding var mainViewState: MainViewState
    @Binding var buttonTappedState: ButtonTappedState
    @Binding var text: String
    @Binding var isFirst: Bool
    @Binding var isSpeechAuth: Bool
    
    var startRecord: () -> Void
    var finishRecord: () -> Void
    
    var body: some View {
        VStack {
            Button(action: {
                switch buttonTappedState {
                    case .noneTapped, .myVoiceButtonTapped:
                        isFirst = false
                        SFSpeechRecognizer.requestAuthorization { authStatus in
                            DispatchQueue.main.async {
                                switch authStatus {
                                    case .authorized:
                                        AVAudioSession.sharedInstance().requestRecordPermission { success in
                                            withAnimation(.easeIn) {
                                                if success {
                                                    // MARK: 순서 중요!! 먼저 녹음을 시작하고 상태를 바꿔줘야함!!!!!
                                                    mainViewState = .mikePassed
                                                    buttonTappedState = .partnerVoiceButtonTapped
                                                    self.startRecord()
                                                    
                                                    
                                                } else {
                                                    rv.presentAuthorizationDeniedAlert(alarmTitle: "마이크 권한 허용이 필요합니다.", alarmMessage: "음성인식 기능 사용을 위해 설정으로 이동해 마이크 권한을 허용해주세요.")
                                                }
                                            }
                                        }
                                    case .denied, .restricted, .notDetermined:
                                        withAnimation(.easeIn) {
                                            rv.presentAuthorizationDeniedAlert(alarmTitle: "음성인식 권한 허용이 필요합니다.", alarmMessage: "음성인식 기능 사용을 위해 설정으로 이동해 음성인식 권한을 허용해주세요.")
                                        }
                                    @unknown default:
                                        withAnimation(.spring()) {
                                            rv.presentAuthorizationDeniedAlert(alarmTitle: "음성인식 권한 허용이 필요합니다!", alarmMessage: "원활한 앱 사용을 위해 음성인식 권한을 허용해주세요.")
                                        }
                                }
                            }
                        }
                    case .partnerVoiceButtonTapped:
                        self.finishRecord()
                        if !text.isEmpty && text != "듣는중.." && mainViewState != .mikePassed {
                            DataController().addRecent(sentence: text, context: managedObjContext)
                        }
                        else if text.isEmpty{
                            buttonTappedState = .noneTapped
                            text = ""
                            mainViewState = .idle
                        }
                        else {
                            text = ""
                        }
                        buttonTappedState = .noneTapped
                }
            }, label: {
                ZStack{
                    Color.mainPurple
                    switch buttonTappedState {
                        case .noneTapped, .myVoiceButtonTapped:
                            VStack{
                                Spacer()
                                Image("micIcon")
                                    .resizable()
                                    .offset(y : mainViewState != .mikePassed ? 0 : 50)
                                    .frame(width: 27, height: 66)
                                    .foregroundColor(.white)
                                
                            }
                        case .partnerVoiceButtonTapped:
                            Image(systemName: "square.fill")
                                .resizable()
                                .frame(width: 32, height: 32)
                                .foregroundColor(.white)
                                .font(.headline)
                    }
                }
                .frame(width: 88, height: 88)
                .cornerRadius(30)
            })
            
            Text("상대 마이크")
                .font(.customCaption())
                .padding(.top, 15)
        }
    }
}

struct PartnerVoiceRecordView_Previews: PreviewProvider {
    static var previews: some View {
        PartnerVoiceRecordView(mainViewState: .constant(.idle), buttonTappedState: .constant(.noneTapped), text: .constant("asdf"), isFirst: .constant(true), isSpeechAuth: .constant(true), startRecord: {
            print("voice record start")
        }, finishRecord: {
            print("voice record finished")
        })
    }
}
