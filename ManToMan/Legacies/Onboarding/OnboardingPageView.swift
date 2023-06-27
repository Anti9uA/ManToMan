//
//  OnboardingPageView.swift
//  ManToMan
//
//  Created by Kyubo Shim on 2023/02/16.
//

import SwiftUI

struct OnboardingPageView: View {
    var onboardingPage: OnboardingPage
    @Binding var pageIndex: Int
    
    var body: some View {
        ZStack{
            VStack(spacing: 45) {
                Image(onboardingPage.imageUrl)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 240)
                    .padding(.top, 50)
                
                
                Text(onboardingPage.description)
                    .font(.customTitle())
                    .foregroundColor(.mainBlue)
                    .multilineTextAlignment(.center)
            }
            if pageIndex == 1 {
                LottieView(filename: "hand", lastTime: 1)
                    .scaledToFill()
                    .frame(height: 300)
                    .padding(.trailing, 200)
                    .padding(.top, 200)
                    .ignoresSafeArea()
            }
            if pageIndex == 2 {
                LottieView(filename: "hand", lastTime: 1)
                    .scaledToFill()
                    .frame(height: 300)
                    .padding(.trailing, 200)
                    .padding(.top, 450)
                    .ignoresSafeArea()
            }
        }
    }
}

