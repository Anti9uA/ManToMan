//
//  TestButtonView.swift
//  Kyupago
//
//  Created by Kyubo Shim on 2023/01/28.
//

import SwiftUI

struct RecordButtonView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var recent: FetchedResults<Recent>
    
    @State var buttonOffset: CGFloat = 0.0
    // 전체 Zstack의 높이 - 패딩값
    @State var buttonheight : Double = 150
    @State var fixedVar: CGFloat = 90
    @State var micTransitionToggle: Bool = false
    @State var overlayToggle: Bool = false
    @State var delay1 = 0.1
    @State var delay2 = 0.3
    @State var delay3 = 0.8
    
    @Binding var flipSpeaker: Bool
    @Binding var text: String
    
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
                    Circle()
                        .fill(Color.customDarkGray)
                }
                .frame(height: fixedVar, alignment: .center)
                .offset(y: buttonOffset)
                .gesture(
                    DragGesture()
                        .onChanged({ gesture in
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
                            withAnimation(.spring()){
                                if currentHeight > 150 && gesture.translation.height < 0.0 {
                                    print("toggled!")
                                    flipSpeaker = true
                                    micTransitionToggle.toggle()
                                    overlayToggle.toggle()
                                    buttonOffset = -80
                                    self.startRecord()
                                    
                                }
                                else {
                                    buttonOffset = 0
                                }
                            }
                        })
                )
                .onTapGesture {
                    flipSpeaker = false
                    overlayToggle.toggle()
                    self.startRecord()
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
                            .frame(width: 44, height: 141)
                            .transition(.move(edge: .bottom))
                            .animation(.easeIn(duration: 0.4).delay(delay2))
                            .onAppear{ self.delay2 = 0.3}
                            .onDisappear{ self.delay2 = 0.3}
                    }
                }
                
                VStack {
                    Spacer()
                    if overlayToggle {
                        LottieView(filename: "speaking")
                            .frame(width: 60, height: 30)
                        ZStack{
                            Capsule()
                                .fill(Color.mainBlue.opacity(0.9))
                                .frame(height: currentHeight)
                            VStack{
                                Image(systemName: "square.fill")
                                    .resizable()
                                    .frame(width: 32, height: 32)
                                    .foregroundColor(.white)
                                    .font(.headline)
                                if flipSpeaker {
                                    Text("STOP")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        .transition(.opacity.animation(.easeIn(duration: 0.3).delay(flipSpeaker ? delay3 : 0)))
                        .onTapGesture {
                            if !text.isEmpty && text != "음성 인식 중.." && !flipSpeaker {
                                DataController().addRecent(sentence: text, context: managedObjContext)
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
        RecordButtonView(flipSpeaker: .constant(true), text: .constant("asdf"), startRecord: {
            print("voice record start")
        }, finishRecord: {
            print("voice record finished")
        })
    }
}
