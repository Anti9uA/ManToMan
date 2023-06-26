//
//  OnboardingPageModel.swift
//  ManToMan
//
//  Created by Kyubo Shim on 2023/02/16.
//

import Foundation
import SwiftUI

struct OnboardingPage: Identifiable, Equatable {
    let id = UUID()
    var description: LocalizedStringKey
    var imageUrl: String
    var tag: Int
    
    static var OnboardingResources: [OnboardingPage] = [
        OnboardingPage(description: "onboarding_description_0", imageUrl: NSLocalizedString("onboardingImage0", comment: ""), tag: 0),
        OnboardingPage(description: "onboarding_description_1", imageUrl: NSLocalizedString("onboardingImage1", comment: ""), tag: 1),
        OnboardingPage(description: "onboarding_description_2", imageUrl: NSLocalizedString("onboardingImage2", comment: ""), tag: 2),
    ]
}

enum OnboardingState {
    case page1
    case page2
    case page3
    case page4
}
//    static var ENOnboardingResources: [OnboardingPage] = [
//        OnboardingPage(description: "You can talk Face to Face!", imageUrl: "onboarding1", tag: 0),
//        OnboardingPage(description: "Search fastly from recent records!", imageUrl: "onboarding2", tag: 1),
//        OnboardingPage(description: "Drag the microphone\nto translate the action", imageUrl: "onboarding3", tag: 2),
//    ]


