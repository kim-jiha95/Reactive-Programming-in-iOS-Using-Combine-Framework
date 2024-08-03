//
//  ContentView.swift
//  combine_ReactiveProgramming
//
//  Created by Jihaha kim on 8/2/24.
//

import SwiftUI
import Combine

struct ContentView: View {
    let numbersPublisher = [1,2,3,4,5,6].publisher
    let doublePublisher = numbersPublisher.map { $0 * 2 }

    let cancellable = doublePublisher.sink { value in
        print(value)
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
