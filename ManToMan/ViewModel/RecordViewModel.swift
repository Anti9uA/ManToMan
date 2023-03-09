//
//  RecordViewModel.swift
//  ManToMan
//
//  Created by Kyubo Shim on 2023/03/09.
//

import Foundation
import SwiftUI
import Speech

class RecordViewModel: ObservableObject {
    func presentAuthorizationDeniedAlert(title: String, message: String) {
        DispatchQueue.main.async {
            guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                return
            }
            if let window = scene.windows.first(where: { $0.isKeyWindow }) {
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "취소", style: .cancel))
                alert.addAction(UIAlertAction(title: "설정으로 이동", style: .default) { _ in
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                })
                window.rootViewController?.present(alert, animated: true, completion: nil)
            }
        }
    }
}
