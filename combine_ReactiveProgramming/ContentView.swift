//
//  ContentView.swift
//  combine_ReactiveProgramming
//
//  Created by Jihaha kim on 8/2/24.
//

import SwiftUI
import Combine

/*
let numbersPublisher = (1...5).publisher

let squaredPublisher = numbersPublisher.map { "Item# \($0)" }

let cancellable = squaredPublisher.sink { value in
    print(value)
} */

// flatMap

/*
let namePublisher = ["John", "Mary", "Steven"].publisher

let flattedNamePublisher = namePublisher.flatMap { name in
    name.publisher
}

let cancellable = flattedNamePublisher
    .sink { char in
        print(char)
    }
 
 */

// merge

let publisher1 = [1,2,3].publisher
let publisher2 = [4,5,6].publisher
let publisher3 = ["A", "B"].publisher

let mergedPublisher = Publishers.Merge(publisher1, publisher2)

let cancellable = mergedPublisher.sink { value in
    print(value)
}

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
