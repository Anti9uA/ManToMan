//
//  TestButtonView.swift
//  Kyupago
//
//  Created by Kyubo Shim on 2023/01/28.
//

import SwiftUI
import Speech

struct RecordButtonView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @StateObject var rv = RecordViewModel()
    @State var buttonOffset: CGFloat = 0.0
    @State var buttonheight : Double = 150
    @State var fixedVar: CGFloat = 90
    @State var micTransitionToggle: Bool = false
    @State var overlayToggle: Bool = false
    @State var delay1 = 0.1
    @State var delay2 = 0.3
    @State var delay3 = 0.8
    @State private var isAnimationPlaying = true
    
    @Binding var mainViewState: MainViewState
    @Binding var text: String
    @Binding var isFirst: Bool
    @Binding var isSpeechAuth: Bool
    
    var startRecord: () -> Void
    var finishRecord: () -> Void
    
    var body: some View {
        ZStack{
            // 다이나믹하게 변하는 캡슐
            // 위로 올라가는건 -값이기에 뺄셈으로 계산해서 높이를 --로 더해줌
            let currentHeight = fixedVar - buttonOffset
            VStack{
                Spacer()
                Capsule()
                    .fill(Color.customDarkGray)
                    .frame(width: fixedVar, height: currentHeight)
            }
            
            // 움직이는 원
            VStack{
                Spacer()
                ZStack {
                    Capsule()
                        .fill(Color.mainBlue)
                }
                .frame(height: fixedVar, alignment: .center)
                .offset(y: buttonOffset)
                .gesture(
                    DragGesture()
                        .onChanged({ gesture in
                            isFirst = false
                            withAnimation(.spring()) {
                                if gesture.translation.height < 0.0{
                                    if currentHeight >= fixedVar && currentHeight < 150{
                                        buttonOffset = gesture.translation.height
                                    }
                                }
                                if gesture.translation.height > 0.0 {
                                    buttonOffset = 0
                                }
                                
                            }
                        })
                        .onEnded({ gesture in
                            SFSpeechRecognizer.requestAuthorization { authStatus in
                                DispatchQueue.main.async {
                                    switch authStatus {
                                        case .authorized:
                                            AVAudioSession.sharedInstance().requestRecordPermission { success in
                                                withAnimation(.spring()) {
                                                    if success {
                                                        if currentHeight > 150 && gesture.translation.height < 0.0 {
                                                            mainViewState = .mikePassed
                                                            self.startRecord()
                                                            print("toggled!")
                                                            buttonOffset = -80
                                                            micTransitionToggle.toggle()
                                                            overlayToggle.toggle()
                                                        } else {
                                                            buttonOffset = 0
                                                        }
                                                    } else {
                                                        buttonOffset = 0
                                                        rv.presentAuthorizationDeniedAlert(alarmTitle: "마이크 권한 허용이 필요합니다.", alarmMessage: "음성인식 기능 사용을 위해 설정으로 이동해 마이크 권한을 허용해주세요.")
                                                    }
                                                }
                                            }
                                        case .denied, .restricted, .notDetermined:
                                            withAnimation(.spring()) {
                                                buttonOffset = 0
                                                rv.presentAuthorizationDeniedAlert(alarmTitle: "음성인식 권한 허용이 필요합니다.", alarmMessage: "음성인식 기능 사용을 위해 설정으로 이동해 음성인식 권한을 허용해주세요.")
                                            }
                                        @unknown default:
                                            withAnimation(.spring()) {
                                                buttonOffset = 0
                                                rv.presentAuthorizationDeniedAlert(alarmTitle: "음성인식 권한 허용이 필요합니다!", alarmMessage: "원활한 앱 사용을 위해 음성인식 권한을 허용해주세요.")
                                            }
                                    }
                                }
                            }
                            
                        })
                )
                .onTapGesture {
                    isFirst = false
                    SFSpeechRecognizer.requestAuthorization { authStatus in
                        DispatchQueue.main.async {
                            switch authStatus {
                                case .authorized:
                                    AVAudioSession.sharedInstance().requestRecordPermission { success in
                                        withAnimation(.spring()) {
                                            if success {
                                                mainViewState = .mikeOwned
                                                self.startRecord()
                                                overlayToggle.toggle()
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
                }
            }
            
            Group{
                VStack{
                    Spacer()
                    if !micTransitionToggle {
                        Image(systemName: "mic.fill")
                            .resizable()
                            .frame(width: 30, height: 42)
                            .foregroundColor(.white)
                            .transition(AnyTransition.scale.animation(.easeInOut(duration: 0.3).delay(delay1)))
                            .onAppear{ self.delay1 = 0.1 }
                            .onDisappear{ self.delay1 = 0.6}
                    }
                }
                .padding(.vertical, fixedVar / 4)
                
                VStack {
                    Spacer()
                    if micTransitionToggle {
                        Image("longMic")
                            .resizable()
                            .scaledToFit()
                            .transition(.move(edge: .bottom))
                            .animation(.easeIn(duration: 0.4).delay(delay2))
                            .onAppear{ self.delay2 = 0.3}
                            .onDisappear{ self.delay2 = 0.3}
                    }
                }
                
                VStack {
                    Spacer()
                    if overlayToggle {
                        LottieView(filename: "speaking", lastTime: .infinity)
                            .frame(width: 60, height: 30)
                        ZStack{
                            Capsule()
                                .fill(Color.mainBlue)
                                .frame(height: currentHeight)
                            VStack{
                                Image(systemName: "square.fill")
                                    .resizable()
                                    .frame(width: 32, height: 32)
                                    .foregroundColor(.white)
                                    .font(.headline)
                                if mainViewState == .mikePassed {
                                    Text("STOP")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        .transition(.opacity.animation(.easeIn(duration: 0.3).delay(mainViewState == .mikePassed ? delay3 : 0)))
                        .onTapGesture {
                            if !text.isEmpty && text != "듣는중.." && mainViewState != .mikePassed {
                                DataController().addRecent(sentence: text, context: managedObjContext)
                            }
                            else if text.isEmpty{
                                text = ""
                                mainViewState = .idle
                            }
                            else {
                                text = ""
                            }
                            
                            if micTransitionToggle{
                                withAnimation(.easeIn(duration: 0.5)) {
                                    self.finishRecord()
                                    overlayToggle.toggle()
                                    micTransitionToggle.toggle()
                                }
                                withAnimation(.easeIn(duration: 0.4).delay(0.3)) {
                                    buttonOffset = 0
                                }
                            }
                            else {
                                withAnimation(.easeIn) {
                                    self.finishRecord()
                                    overlayToggle.toggle()
                                }
                            }
                        }
                        .onAppear{ self.delay3 = 0.0 }
                        .onDisappear{ self.delay3 = 0.8}
                    }
                }
            }
        }
        .frame(width: fixedVar, alignment: .center)
    }
}

struct TestButtonView_Previews: PreviewProvider {
    static var previews: some View {
        RecordButtonView(mainViewState: .constant(.idle), text: .constant("asdf"), isFirst: .constant(true), isSpeechAuth: .constant(true), startRecord: {
            print("voice record start")
        }, finishRecord: {
            print("voice record finished")
        })
    }
}
