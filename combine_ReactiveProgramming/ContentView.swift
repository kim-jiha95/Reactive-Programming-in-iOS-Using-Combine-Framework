//
//  ContentView.swift
//  combine_ReactiveProgramming
//
//  Created by Jihaha kim on 8/2/24.
//

import SwiftUI
import Combine

struct ContentView: View {
    let timerPublisher = Timer.publish(every: 1, on: .main, in: .common)
    let cancellable = timerPublisher.autoconnect().sink { timestamp in
        print("Timestamp: \(timestamp)")
    }
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
