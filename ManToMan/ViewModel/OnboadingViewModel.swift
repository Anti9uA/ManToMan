//
//  OnboadingViewModel.swift
//  ManToMan
//
//  Created by Kyubo Shim on 2023/03/01.
//

import Foundation
import SwiftUI

class OnboardingViewModel: ObservableObject {
    @Published var pageIndex = 0
    @Published var onboardingState: OnboardingState = .page1
    @Binding var isFirst: Bool
    
    init(isFirst: Binding<Bool>) {
        self._isFirst = isFirst
    }
    
    func shouldUseCustomFrame() -> Bool {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let horizontalSizeClass = windowScene.windows.first?.rootViewController?.traitCollection.horizontalSizeClass else {
            return false
        }
        
        if horizontalSizeClass == .compact {
            if UIScreen.main.bounds.height == 568 { // iPhone SE
                return true
            } else if UIScreen.main.bounds.height == 667 { // iPod 7
                return true
            }
        }
        
        return false
    }
}
