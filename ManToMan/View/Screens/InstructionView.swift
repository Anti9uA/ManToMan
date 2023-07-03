//
//  InstructionView.swift
//  ManToMan
//
//  Created by Kyubo Shim on 2023/06/23.
//

import SwiftUI

struct InstructionView: View {
    @Environment(\.horizontalSizeClass) var sizeClass
    @StateObject private var lv = LanguageViewModel()
    @StateObject var onboardingViewModel: OnboardingViewModel
    let opacityLevel = 0.8
    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack {
                    ZStack {
                        Color("background")
                            .edgesIgnoringSafeArea(.top)
                            .overlay(Color.black.opacity(opacityLevel))
                        
                        VStack (alignment: .center){
                            HStack {
                                Text("\(lv.currentLang)")
                                    .font(.customTitle())
                                    .foregroundColor(.black)
                                
                                Image(systemName: "chevron.down")
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.disabledBlue)
                            }
                            
                            ZStack (alignment: .bottomTrailing){
                                Rectangle()
                                    .cornerRadius(30)
                                    .frame(width: geo.size.width - 40, height: 220)
                                    .foregroundColor(Color.white)
                                
                                switch onboardingViewModel.onboardingState {
                                    case .page1:
                                        Text("Onboarding_Partner_Sample_Text_1")
                                            .font(.english())
                                            .foregroundColor(.mainPurple)
                                            .rotationEffect(Angle(degrees: 180))
                                            .padding(20)
                                    case .page2:
                                        Text("Onboarding_Partner_Sample_Text_2")
                                            .font(.english())
                                            .foregroundColor(.mainPurple)
                                            .rotationEffect(Angle(degrees: 180))
                                            .padding(20)
                                    case .page3:
                                        Text("Onboarding_Partner_Sample_Text_3")
                                            .font(.english())
                                            .foregroundColor(.mainPurple)
                                            .rotationEffect(Angle(degrees: 180))
                                            .padding(20)
                                    case .page4:
                                        Text("Onboarding_Partner_Sample_Text_4")
                                            .font(.english())
                                            .foregroundColor(.mainPurple)
                                            .rotationEffect(Angle(degrees: 180))
                                            .padding(20)
                                }
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(onboardingViewModel.onboardingState != .page4 ? Color.black.opacity(opacityLevel) : Color.clear)
                            )
                            
                            ZStack (alignment: .leading){
                                Rectangle()
                                    .frame(width: geo.size.width - 40, height: 75)
                                    .cornerRadius(20)
                                    .foregroundColor(.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(onboardingViewModel.onboardingState != .page2 ? Color.black.opacity(opacityLevel) : Color.clear)
                                    )
                                    .overlay(RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.mainBlue.opacity(0.3), lineWidth: 2.5)
                                    )
                                
                                HStack{
                                    switch onboardingViewModel.onboardingState {
                                        case .page1:
                                            Image("head")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 38)
                                            Text("한국어를 입력하세요.")
                                                .font(.korean())
                                                .foregroundColor(.disabledBlue)
                                        case .page2:
                                            Text("Onboarding_User_Sample_Text_1")
                                                .font(.korean())
                                                .foregroundColor(.mainBlue)
                                        case .page3:
                                            Text("Onboarding_User_Sample_Text_2")
                                                .font(.korean())
                                                .foregroundColor(.disabledBlue)
                                        case .page4:
                                            Text("Onboarding_User_Sample_Text_3")
                                                .font(.korean())
                                                .foregroundColor(.disabledBlue)
                                    }
                                    
                                }
                                .opacity((onboardingViewModel.onboardingState == .page2) ? 1 : 0.5)
                                .padding(20)
                                
                            }
                            .padding(.top, 20)
                            
                            Spacer()
                            VStack{
                                HStack {
                                    LottieView(filename: "userSpeakingMotion", lastTime: .infinity)
                                        .frame(width: 60, height: 20)
                                        .opacity(onboardingViewModel.onboardingState == .page2 ? 1 : 0)
                                        .padding(.trailing, 33)
                                    
                                    LottieView(filename: "partnerSpeakingMotion", lastTime: .infinity)
                                        .frame(width: 60, height: 20)
                                        .opacity(onboardingViewModel.onboardingState == .page4 ? 1 : 0)
                                        .padding(.leading, 36)
                                    
                                }
                                HStack{
                                    VStack{
                                        ZStack{
                                            Color.mainBlue
                                            if onboardingViewModel.onboardingState == .page2 {
                                                Image(systemName: "square.fill")
                                                    .resizable()
                                                    .frame(width: 32, height: 32)
                                                    .foregroundColor(.white)
                                                    .font(.headline)
                                            } else {
                                                VStack{
                                                    Spacer()
                                                    
                                                    Image("micIcon")
                                                        .resizable()
                                                        .frame(width: 27, height: 66)
                                                        .foregroundColor(.white)
                                                }
                                            }
                                        }
                                        .frame(width: 88, height: 88)
                                        .cornerRadius(30)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 30)
                                                .fill((onboardingViewModel.onboardingState == .page1) || (onboardingViewModel.onboardingState == .page2) ?  Color.clear : Color.black.opacity(opacityLevel))
                                        )
                                        .onTapGesture {
                                            switch onboardingViewModel.onboardingState {
                                                case .page1:
                                                    onboardingViewModel.onboardingState = .page2
                                                case .page2:
                                                    onboardingViewModel.onboardingState = .page3
                                                case .page3, .page4:
                                                    break
                                            }
                                        }
                                        
                                        Text("내 마이크")
                                            .font(.customCaption())
                                            .padding(.top, 15)
                                        
                                    }
                                    .padding(.trailing, 40)
                                    
                                    
                                    VStack{
                                        ZStack{
                                            Color.mainPurple
                                            if onboardingViewModel.onboardingState == .page4 {
                                                Image(systemName: "square.fill")
                                                    .resizable()
                                                    .frame(width: 32, height: 32)
                                                    .foregroundColor(.white)
                                                    .font(.headline)
                                            } else {
                                                VStack{
                                                    Spacer()
                                                    
                                                    Image("micIcon")
                                                        .resizable()
                                                        .frame(width: 27, height: 66)
                                                        .foregroundColor(.white)
                                                }
                                            }
                                        }
                                        .frame(width: 88, height: 88)
                                        .cornerRadius(30)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 30)
                                                .fill((onboardingViewModel.onboardingState == .page3) || (onboardingViewModel.onboardingState == .page4) ?  Color.clear : Color.black.opacity(opacityLevel))
                                        )
                                        .onTapGesture {
                                            switch onboardingViewModel.onboardingState {
                                                case .page1, .page2:
                                                    break
                                                case .page3:
                                                    onboardingViewModel.onboardingState = .page4
                                                case .page4:
                                                    onboardingViewModel.isFirst = false
                                                    
                                            }
                                        }
                                        
                                        Text("상대 마이크")
                                            .font(.customCaption())
                                            .padding(.top, 15)
                                    }
                                }
                                .frame(height: 130)
                                .padding(.bottom, 15)
                            }
                        }
                        .frame(width: geo.size.width, alignment: .top)
                    }
                    .padding(.top, geo.safeAreaInsets.top)
                    
                    VStack{
                        Text("번역기록")
                            .font(.customTitle())
                            .padding(EdgeInsets(top: 20, leading: 0, bottom: geo.safeAreaInsets.bottom + 7, trailing: 0))
                    }
                    .frame(width: geo.size.width)
                    .background(.background)
                    .cornerRadius(12)
                    .overlay(Color.black.opacity(opacityLevel).cornerRadius(12))
                }
                .background(Color.customLightGray.overlay(Color.black.opacity(opacityLevel)))
                .ignoresSafeArea()
                
                VStack{
                    switch onboardingViewModel.onboardingState {
                        case .page1:
                            Text("Instruction_Sentence_1")
                                .font(.sampleTextFont())
                                .foregroundColor(.white)
                                .padding(.top, 150)
                                .padding(.horizontal)
                                .multilineTextAlignment(.center)
                        case .page2:
                            Text("Instruction_Sentence_2")
                                .font(.sampleTextFont())
                                .foregroundColor(.white)
                                .padding(.top, onboardingViewModel.shouldUseCustomFrame() ? -150 : 150)
                                .padding(.horizontal)
                                .multilineTextAlignment(.center)
                        case .page3:
                            Text("Instruction_Sentence_3")
                                .font(.sampleTextFont())
                                .foregroundColor(.white)
                                .padding(.top, onboardingViewModel.shouldUseCustomFrame() ? 50 : 150)
                                .padding(.horizontal)
                                .multilineTextAlignment(.center)
                        case .page4:
                            Text("Instruction_Sentence_4")
                                .font(.sampleTextFont())
                                .foregroundColor(.white)
                                .padding(.top, onboardingViewModel.shouldUseCustomFrame() ? 50 : 150)
                                .multilineTextAlignment(.center)
                    }
                }
            }
            //            .onTapGesture {
            //                switch onboardingViewModel.onboardingState {
            //                    case .page1:
            //                        onboardingViewModel.onboardingState = .page2
            //                    case .page2:
            //                        onboardingViewModel.onboardingState = .page3
            //                    case .page3:
            //                        onboardingViewModel.onboardingState = .page4
            //                    case .page4:
            //                        onboardingViewModel.isFirst = false
            //                }
            //            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

struct InstructionView_Previews: PreviewProvider {
    static var previews: some View {
        InstructionView(onboardingViewModel: OnboardingViewModel(isFirst: .constant(true)))
    }
}
