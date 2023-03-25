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
                let localizedTitle = NSLocalizedString(title, comment: "")
                let localizedMessage = NSLocalizedString(message, comment: "")
                let alert = UIAlertController(title: localizedTitle, message: localizedMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("취소", comment: ""), style: .cancel))
                alert.addAction(UIAlertAction(title: NSLocalizedString("설정으로 이동", comment: ""), style: .default) { _ in
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                })
                window.rootViewController?.present(alert, animated: true, completion: nil)
            }
        }
    }
}
