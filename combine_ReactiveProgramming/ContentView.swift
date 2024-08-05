//
//  ContentView.swift
//  combine_ReactiveProgramming
//
//  Created by Jihaha kim on 8/2/24.
//

import SwiftUI
import Combine

// filter
/*
let numbersPublisher = (1...10).publisher

let evenNumberPublisher = numbersPublisher.filter { $0 % 2 == 0}

let cancellable = evenNumberPublisher.sink { value in
    print(value)
} */

// compactMap
/*
let stringsPublisher = ["1", "2", "3", "4", "A"].publisher

let numbersPublisher = stringsPublisher.compactMap { Int($0) }

let cancellable = numbersPublisher.sink { value in
    print(value)
} */

// debounce

let textPublisher = PassthroughSubject<String, Never>()

let debouncedPublisher = textPublisher.debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)

let cancellable = debouncedPublisher.sink { value in
    print(value)
}

textPublisher.send("A")
textPublisher.send("B")
textPublisher.send("C")
textPublisher.send("D")
textPublisher.send("E")
textPublisher.send("F")

class ContentViewModel: ObservableObject {
    
    @Published var value: Int = 0
    private var cancellable: AnyCancellable?
    
    init() {
        
        let publisher = Timer.publish(every: 1.0, on: .main, in: .default)
            .autoconnect()
            .map {
                _  in self.value + 1
            }
        
        cancellable = publisher.assign(to: \.value, on: self)
        
    }
}

struct ContentView: View {
    
    @StateObject private var vm = ContentViewModel()
    
    var body: some View {
        VStack {
            Text("\(vm.value)")
                .font(.largeTitle)
        }
        .padding()
    }

}

#Preview {
    ContentView()
}
