//
//  SampleButtonView.swift
//  ManToMan
//
//  Created by Kyubo Shim on 2023/06/11.
//

import SwiftUI
import Speech

struct SampleButtonView: View {
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
        Button(action: {
            switch buttonTappedState {
                case .noneTapped, .myVoiceButtonTapped:
                    isFirst = false
                    self.finishRecord()
                    SFSpeechRecognizer.requestAuthorization { authStatus in
                        DispatchQueue.main.async {
                            switch authStatus {
                                case .authorized:
                                    AVAudioSession.sharedInstance().requestRecordPermission { success in
                                        withAnimation(.easeInOut) {
                                            if success {
                                                if mainViewState == .mikeOwned {
                                                    self.finishRecord()
                                                }
                                                // MARK: 순서 중요!! 먼저 녹음을 시작하고 상태를 바꿔줘야함!!!!!
                                                self.startRecord()
                                                mainViewState = .mikePassed
                                                buttonTappedState = .partnerVoiceButtonTapped
                                            } else {
                                                rv.presentAuthorizationDeniedAlert(alarmTitle: "마이크 권한 허용이 필요합니다.", alarmMessage: "음성인식 기능 사용을 위해 설정으로 이동해 마이크 권한을 허용해주세요.")
                                            }
                                        }
                                    }
                                case .denied, .restricted, .notDetermined:
                                    withAnimation(.spring()) {
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
                    self.finishRecord()
                    buttonTappedState = .noneTapped
            }
        }, label: {
            ZStack{
                Color.blue
                switch buttonTappedState {
                    case .noneTapped, .myVoiceButtonTapped:
                        Image(systemName: "star.fill")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundColor(.white)
                            .font(.headline)
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
    }
}

struct SampleButtonView_Previews: PreviewProvider {
    static var previews: some View {
        SampleButtonView(mainViewState: .constant(.idle), buttonTappedState: .constant(.noneTapped), text: .constant("asdf"), isFirst: .constant(true), isSpeechAuth: .constant(true), startRecord: {
            print("voice record start")
        }, finishRecord: {
            print("voice record finished")
        })
    }
}
