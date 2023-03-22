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
    @Binding var isFirst: Bool
    let pages: [OnboardingPage] = OnboardingPage.OnboardingResources
    
    init(isFirst: Binding<Bool>) {
        self._isFirst = isFirst
    }
    
    func incrementPage() {
        pageIndex += 1
    }
    
    func goToZero() {
        pageIndex = 0
    }
}
