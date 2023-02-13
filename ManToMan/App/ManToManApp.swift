//
//  ManToManApp.swift
//  ManToMan
//
//  Created by Kyubo Shim on 2023/01/27.
//

import SwiftUI

@main
struct ManToManApp: App {
    @StateObject private var dataController = DataController()
    @State var isFirst: Bool = true
    var body: some Scene {
        WindowGroup {
            if isFirst {
                LaunchScreenView()
                    .onAppear{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            self.isFirst.toggle()
                        }
                    }
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
