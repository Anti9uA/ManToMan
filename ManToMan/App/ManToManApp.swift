//
//  ManToManApp.swift
//  ManToMan
//
//  Created by Kyubo Shim on 2023/01/27.
//

import SwiftUI

@main
struct ManToManApp: App {
    @AppStorage("Onboarding") var isFirst: Bool = true
    @StateObject private var dataController = DataController()
    @State var isStart: Bool = true
    
    var body: some Scene {
        WindowGroup {
            if isStart {
                LaunchScreenView()
                    .onAppear{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            self.isStart.toggle()
                        }
                    }
            }
            else {
                if isFirst {
                    InstructionView(onboardingViewModel: OnboardingViewModel(isFirst: $isFirst))
                    // OnboardingView(viewModel: OnboardingViewModel(isFirst: $isFirst))
                }
                else {
                    MainView()
                        .environment(\.managedObjectContext,
                                      dataController.container.viewContext)
                        .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
                }
            }
        }
    }
}
