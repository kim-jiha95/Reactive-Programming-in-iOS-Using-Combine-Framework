//
//  ContentView.swift
//  combine_ReactiveProgramming
//
//  Created by Jihaha kim on 8/2/24.
//

import SwiftUI
import Combine

struct Post: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

enum NetworkError: Error {
    case badServerResponse
}

func fetchPosts() -> AnyPublisher<[Post], Error> {
    
    let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
    
    return URLSession.shared.dataTaskPublisher(for: url)
        .tryMap { data, response in
            print("retries")
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw NetworkError.badServerResponse
            }
            
            return data
        }
        .decode(type: [Post].self, decoder: JSONDecoder())
        .retry(3)
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
}

var cancellables: Set<AnyCancellable> = []

fetchPosts()
    .sink { completion in
        switch completion {
            case .finished:
                print("Update UI")
            case .failure(let error):
                print(error)
        }
    } receiveValue: { posts in
        print(posts)
    }.store(in: &cancellables)

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
