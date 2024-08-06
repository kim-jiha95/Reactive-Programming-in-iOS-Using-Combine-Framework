//
//  ContentView.swift
//  combine_ReactiveProgramming
//
//  Created by Jihaha kim on 8/2/24.
//

import SwiftUI
import Combine

/*
let numbersPublisher = [1,2,3,4,5,6].publisher

let transformedPublisher = numbersPublisher
    .tryMap { value in
        if value == 3 {
            throw SampleError.operationFailed
        }
        
        return value
    }.catch { error in
        print(error)
        return Just(0)
    }

transformedPublisher.sink { value in
    print(value)
} */


// replaceError with single value

/*
let numbersPublisher = [1,2,3,4,5,6].publisher

let transformedPublisher = numbersPublisher
    .tryMap { value in
        if value == 3 {
            throw SampleError.operationFailed
        }
        
        return value * 2
    }.replaceError(with: -1)


let cancellable = transformedPublisher.sink { value in
    print(value)
}
*/

// replaceError with another publisher

/*
let numbersPublisher = [1,2,3,4,5,6].publisher

let fallbackPublisher = Just(-1)

let transformedPublisher = numbersPublisher
    .tryMap { value in
        if value == 3 {
            throw SampleError.operationFailed
        }
        return Just(value * 2)
}.replaceError(with: fallbackPublisher)

let cancellable = transformedPublisher.sink { publisher in
    let _ = publisher.sink { value in
        print(value)
    }
} */

// retry

let publisher = PassthroughSubject<Int, Error>()

let retriedPublisher = publisher
    .tryMap { value in
        if value == 3 {
            throw SampleError.operationFailed
        }
        return value
    }.retry(2)

let cancellable = retriedPublisher.sink { completion in
    switch completion {
        case .finished:
            print("Pubisher has completed.")
        case .failure(let error):
            print("Publisher failed with error \(error)")
    }
} receiveValue: { value in
    print(value)
}

publisher.send(1)
publisher.send(2)
publisher.send(3) // failed
publisher.send(4)
publisher.send(5)
publisher.send(3) // failed
publisher.send(6)
publisher.send(7)
publisher.send(3) // failed
publisher.send(8)

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
