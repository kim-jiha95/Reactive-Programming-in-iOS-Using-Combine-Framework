//
//  ContentView.swift
//  combine_ReactiveProgramming
//
//  Created by Jihaha kim on 8/2/24.
//

import SwiftUI
import Combine

// combineLatest
/*
let publisher1 = CurrentValueSubject<Int, Never>(1)
let publisher2 = CurrentValueSubject<String, Never>("Hello World")

let combinedPublisher = publisher1.combineLatest(publisher2)

let cancellable = combinedPublisher.sink { value1, value2 in
    print("Value 1: \(value1), Value 2: \(value2)")
}

publisher1.send(3)
publisher2.send("Introduction to Combine")
 */

// zip
/*
let publisher1 = [1,2,3,4].publisher
let publisher2 = ["A", "B", "C", "D", "E"].publisher
let publisher3 = ["John", "Doe", "Mary", "Steven"].publisher

//let zippedPublisher = publisher1.zip(publisher2)

let zippedPublisher = Publishers.Zip3(publisher1, publisher2, publisher3)

let cancellable = zippedPublisher.sink { value in
    print("\(value.0), \(value.1), \(value.2)")
} */


// switchToLatest

let outerPublisher = PassthroughSubject<AnyPublisher<Int, Never>, Never>()
let innerPublisher1 = CurrentValueSubject<Int, Never>(1)
let innerPublisher2 = CurrentValueSubject<Int, Never>(2)

let cancellable = outerPublisher
    .switchToLatest()
    .sink { value in
        print(value)
}

outerPublisher.send(AnyPublisher(innerPublisher1))
innerPublisher1.send(10)

outerPublisher.send(AnyPublisher(innerPublisher2))
innerPublisher2.send(20)
// 1은 받지 않음, line 56때문에
//innerPublisher1.send(100)
innerPublisher2.send(100)

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
