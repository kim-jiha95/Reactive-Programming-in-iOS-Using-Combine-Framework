//
//  ContentView.swift
//  combine_ReactiveProgramming
//
//  Created by Jihaha kim on 8/2/24.
//

import SwiftUI
import Combine

enum NumberError: Error {
    case operationFailed
}

let numbersPublisher = [1, 2, 3, 4, 5].publisher

let doubledPublisher = numbersPublisher
    .tryMap { number in
        if number == 4 {
            throw NumberError.operationFailed
        }
        
        return number * 2
        
    }.mapError { error in
        return NumberError.operationFailed
    }

let cancellable = doubledPublisher.sink { completion in
    switch completion {
        case .finished:
            print("finished")
        case .failure(let error):
            print(error)
    }
} receiveValue: { value in
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
//            Text("\(vm.value)")
//                .font(.largeTitle)
        }
        .padding()
    }

}

#Preview {
    ContentView()
}
