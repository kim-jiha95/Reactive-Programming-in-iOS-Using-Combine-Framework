//
//  combine_ReactiveProgrammingApp.swift
//  combine_ReactiveProgramming
//
//  Created by Jihaha kim on 8/2/24.
//

import SwiftUI
import Combine

@main
struct combine_ReactiveProgrammingApp: App {
    var body: some Scene {
        private var cancellables: Set<AnyCancellable> = []
        
        init() {
            NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
                .sink { _ in
                    let currentOrientation = UIDevice.current.orientation
                    print(currentOrientation)
                }.store(in: &cancellables)
        }
        WindowGroup {
            ContentView()
        }
    }
}
