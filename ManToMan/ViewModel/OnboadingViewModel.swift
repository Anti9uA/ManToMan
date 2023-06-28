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
}
