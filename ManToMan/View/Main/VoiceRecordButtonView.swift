//
//  VoiceRecordButtonView.swift
//  ManToMan
//
//  Created by Kyubo Shim on 2023/05/11.
//

import SwiftUI

struct VoiceRecordButtonView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @StateObject var rv = RecordViewModel()
    @State var buttonOffset: CGFloat = 0.0
    @State var buttonheight : Double = 100
    @State var fixedVar: CGFloat = 90
    
    @State var overlayToggle = false
    @State var micTransitionToggle: Bool = false
    @State var changeBackground = false
    
    var body: some View {
        let currentHeight = fixedVar - buttonOffset
        VStack{
            Spacer()
            ZStack(alignment: .bottom){
                Rectangle()
                    .fill(Color.red)
                    .cornerRadius(35)
                    .frame(width: fixedVar, height: 150, alignment: .center)
                Rectangle()
                    .fill(Color.mainBlue)
                    .frame(width: fixedVar, height: currentHeight)
                    .cornerRadius(35)
                
                ZStack (alignment: .bottom){
                    Rectangle()
                        .fill(Color.black)
                        .cornerRadius(35)
                        .frame(width: fixedVar, height: fixedVar, alignment: .center)
                    Image("longMic")
                        .resizable()
                        .frame(width: 85, height: 150)
                        .offset(y: 60)
                    
                }
                .offset(y: buttonOffset)
                .gesture(
                    DragGesture()
                        .onChanged({ gesture in
                            // isFirst = false
                            withAnimation(.spring()) {
                                if gesture.translation.height < 0.0{
                                    if currentHeight >= fixedVar && currentHeight < 140{
                                        buttonOffset = gesture.translation.height
                                    }
                                }
                                if gesture.translation.height > 0.0 {
                                    buttonOffset = 0
                                }
                                
                            }
                        })
                    //                    .onEnded({ gesture in
                    //                        SFSpeechRecognizer.requestAuthorization { authStatus in
                    //                            DispatchQueue.main.async {
                    //                                switch authStatus {
                    //                                    case .authorized:
                    //                                        AVAudioSession.sharedInstance().requestRecordPermission { success in
                    //                                            withAnimation(.spring()) {
                    //                                                if success {
                    //                                                    if currentHeight > 150 && gesture.translation.height < 0.0 {
                    //                                                        mainViewState = .mikePassed
                    //                                                        self.startRecord()
                    //                                                        print("toggled!")
                    //                                                        buttonOffset = -80
                    //                                                        micTransitionToggle.toggle()
                    //                                                        overlayToggle.toggle()
                    //                                                    } else {
                    //                                                        buttonOffset = 0
                    //                                                    }
                    //                                                } else {
                    //                                                    buttonOffset = 0
                    //                                                    rv.presentAuthorizationDeniedAlert(alarmTitle: "마이크 권한 허용이 필요합니다.", alarmMessage: "음성인식 기능 사용을 위해 설정으로 이동해 마이크 권한을 허용해주세요.")
                    //                                                }
                    //                                            }
                    //                                        }
                    //                                    case .denied, .restricted, .notDetermined:
                    //                                        withAnimation(.spring()) {
                    //                                            buttonOffset = 0
                    //                                            rv.presentAuthorizationDeniedAlert(alarmTitle: "음성인식 권한 허용이 필요합니다.", alarmMessage: "음성인식 기능 사용을 위해 설정으로 이동해 음성인식 권한을 허용해주세요.")
                    //                                        }
                    //                                    @unknown default:
                    //                                        withAnimation(.spring()) {
                    //                                            buttonOffset = 0
                    //                                            rv.presentAuthorizationDeniedAlert(alarmTitle: "음성인식 권한 허용이 필요합니다!", alarmMessage: "원활한 앱 사용을 위해 음성인식 권한을 허용해주세요.")
                    //                                        }
                    //                                }
                    //                            }
                    //                        }
                    //
                    //                    })
                    
                )
                .onTapGesture {
                    withAnimation {
                        overlayToggle.toggle()
                    }
                    
//                    isFirst = false
//                    SFSpeechRecognizer.requestAuthorization { authStatus in
//                        DispatchQueue.main.async {
//                            switch authStatus {
//                                case .authorized:
//                                    AVAudioSession.sharedInstance().requestRecordPermission { success in
//                                        withAnimation(.spring()) {
//                                            if success {
//                                                // mainViewState = .mikeOwned
//                                                self.startRecord()
//                                                overlayToggle.toggle()
//                                            } else {
//                                                rv.presentAuthorizationDeniedAlert(alarmTitle: "마이크 권한 허용이 필요합니다.", alarmMessage: "음성인식 기능 사용을 위해 설정으로 이동해 마이크 권한을 허용해주세요.")
//                                            }
//                                        }
//                                    }
//                                case .denied, .restricted, .notDetermined:
//                                    withAnimation(.spring()) {
//                                        rv.presentAuthorizationDeniedAlert(alarmTitle: "음성인식 권한 허용이 필요합니다.", alarmMessage: "음성인식 기능 사용을 위해 설정으로 이동해 음성인식 권한을 허용해주세요.")
//                                    }
//                                @unknown default:
//                                    withAnimation(.spring()) {
//                                        rv.presentAuthorizationDeniedAlert(alarmTitle: "음성인식 권한 허용이 필요합니다!", alarmMessage: "원활한 앱 사용을 위해 음성인식 권한을 허용해주세요.")
//                                    }
//                            }
//                        }
//                    }

                        
                        
                    
                }
                if overlayToggle{
                    LottieView(filename: "speaking", lastTime: .infinity)
                        .frame(width: 60, height: 30)
                    ZStack{
                        Rectangle()
                            .fill(Color.mainBlue)
                            .cornerRadius(35)
                            .frame(width: fixedVar, height: currentHeight)
                        VStack{
                            Image(systemName: "square.fill")
                                .resizable()
                                .frame(width: 32, height: 32)
                                .foregroundColor(.white)
                                .font(.headline)
                            //                                if mainViewState == .mikePassed {
                            //                                    Text("STOP")
                            //                                        .font(.system(size: 20, weight: .bold))
                            //                                        .foregroundColor(.white)
                            //                                }
                        }
                    }
                }
            }   // end ZStack
        }   // end Vstack
    }
}

struct VoiceRecordButtonView_Previews: PreviewProvider {
    static var previews: some View {
        VoiceRecordButtonView()
    }
}
