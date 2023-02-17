//
//  OnboardingPageModel.swift
//  ManToMan
//
//  Created by Kyubo Shim on 2023/02/16.
//

import Foundation

struct OnboardingPage: Identifiable, Equatable {
    let id = UUID()
    var description: String
    var imageUrl: String
    var tag: Int
    
    static var samplePage = OnboardingPage(description: "This is a sample description for the purpose of debugging", imageUrl: "work", tag: 0)
    
    static var samplePages: [OnboardingPage] = [
        OnboardingPage(description: "상대방과 마주보며 대화해보세요", imageUrl: "onboarding1", tag: 0),
        OnboardingPage(description: "번역 기록에서 빠르게 말을 불러와요", imageUrl: "onboarding2", tag: 1),
        OnboardingPage(description: "마이크를 건네 대답도 번역해 보세요!", imageUrl: "onboarding3", tag: 2),
    ]
}
