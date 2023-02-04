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
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext,
                              dataController.container.viewContext)
                .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
        }
    }
}
