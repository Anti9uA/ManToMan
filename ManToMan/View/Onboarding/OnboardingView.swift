//
//  OnboardingView.swift
//  ManToMan
//
//  Created by Kyubo Shim on 2023/02/16.
//

import SwiftUI

struct OnboardingView: View {
    @State private var pageIndex = 0
    @Binding var isFirst: Bool
    private let pages: [OnboardingPage] = OnboardingPage.samplePages
    private let dotAppearance = UIPageControl.appearance()
    
    var body: some View {
        ZStack{
            Color.background
                .ignoresSafeArea()
            VStack{
                TabView(selection: $pageIndex) {
                    ForEach(pages) { page in
                        VStack {
                            Spacer()
                            OnboardingPageView(onboardingPage: page, pageIndex: $pageIndex)
                            Spacer()
                        }
                        .tag(page.tag)
                    }
                }
                .animation(.easeInOut, value: pageIndex)// 2
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .overlay(
                    PageControl(pageIndex: pageIndex, pageCount: pages.count)
                        .padding(.top, 36)
                    , alignment: .top
                )
                Button(action: {
                    self.isFirst = false
                }, label: {
                    ZStack{
                        Rectangle()
                            .fill(Color.mainBlue)
                            .cornerRadius(30)
                            .frame(height: 60)
                        
                        Text("시작하기")
                            .foregroundColor(.white)
                            .font(.customTitle())
                    }
                    .padding(.horizontal, 20)
                        
                })
            }
        }
    }
    
    func incrementPage() {
        pageIndex += 1
    }
    
    func goToZero() {
        pageIndex = 0
    }
}

struct PageControl: View {
    var pageIndex: Int
    var pageCount: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<pageCount, id: \.self) { index in
                Circle()
                    .frame(width: 8, height: 8)
                    .foregroundColor(pageIndex == index ? .mainBlue : .customLightGray)
            }
        }
    }
}

//struct OnboardingView_Previews: PreviewProvider {
//    static var previews: some View {
//        OnboardingView()
//    }
//}
