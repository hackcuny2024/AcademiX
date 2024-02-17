//
//  AcademiXApp.swift
//  AcademiX
//
//  Created by Olti Gjoni on 2/16/24.
//

import SwiftUI

@main
struct AcademiXApp: App {
    init() {
        // Force light mode for all UIViews, affecting the entire app
        UIView.appearance().overrideUserInterfaceStyle = .light
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
