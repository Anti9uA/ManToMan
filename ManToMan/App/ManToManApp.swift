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
    @AppStorage("LastRunAppVersionMajor") var lastRunAppVersionMajor: String = ""
    @StateObject private var dataController = DataController()
    @State var isStart: Bool = true
    
    init() {
        handleVersionChange()
    }
    
    var body: some Scene {
        WindowGroup {
            // 앱 최초 실행 체크
            if isStart {
                // 런치 스크린 / 대문 화면
                LaunchScreenView()
                    .onAppear{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            self.isStart.toggle()
                        }
                    }
            }
            else {
                if isFirst {
                    // 온보딩 화면
                    InstructionView(onboardingViewModel: OnboardingViewModel(isFirst: $isFirst))
                } else {
                    MainView()
                        .environment(\.managedObjectContext,
                                      dataController.container.viewContext)
                        .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
                }
            }
        }
        
    }
    
    // 앱 버전 업데이트 여부 확인
    // 주 번호 즉, 1.9.0 -> 2.0.0 업데이트 됐을 시 isFirst 토글
    func handleVersionChange() {
        if let infoDict = Bundle.main.infoDictionary,
           let appVersion = infoDict["CFBundleShortVersionString"] as? String,
           let currentMajorVersion = appVersion.split(separator: ".").first {
            
            if lastRunAppVersionMajor != String(currentMajorVersion) {
                isFirst = true
                lastRunAppVersionMajor = String(currentMajorVersion)
            }
        }
    }
}
