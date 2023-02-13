//
//  LaunchScreenView.swift
//  ManToMan
//
//  Created by Kyubo Shim on 2023/02/13.
//

import SwiftUI

struct LaunchScreenView: View {
    var body: some View {
        LottieView(filename: "launchScreen", lastTime: 1)
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
    }
}
