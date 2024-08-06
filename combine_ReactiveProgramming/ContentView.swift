//
//  ContentView.swift
//  combine_ReactiveProgramming
//
//  Created by Jihaha kim on 8/2/24.
//

import SwiftUI
import Combine

struct MovieResponse: Decodable {
    let Search: [Movie]
}

struct Movie: Decodable {
    let title: String
    
    private enum CodingKeys: String, CodingKey {
        case title = "Title"
    }
}

func fetchMovies(_ searchTerm: String) -> AnyPublisher<MovieResponse, Error> {
    
    let url = URL(string: "https://www.omdbapi.com/?s=\(searchTerm)&page=2&apiKey=564727fa")!
    
    return URLSession.shared.dataTaskPublisher(for: uri)
        .map(\data)
        .decode(type: MovieResponse.self, decoder: JSONDecoder())
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
}

var cancellables: Set<AnyCancellable> = []

Publishers.CombineLatest(fetchMovies("Batman"), fetchMovies("Spiderman"))
    .sink { _ in
        
    } receiveValue: { value1, value2 in
        print(value1.Search)
        print(value2.Search)
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
