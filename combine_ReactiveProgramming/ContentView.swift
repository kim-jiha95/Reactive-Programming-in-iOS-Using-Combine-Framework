//
//  ContentView.swift
//  combine_ReactiveProgramming
//
//  Created by Jihaha kim on 8/2/24.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @State private var movies: [Movie] = []
    @State private var search: String = ""
    
    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    var body: some View {
        List(movies) { movie in
            HStack {
                AsyncImage(url: movie.poster) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 75, height: 75)
                } placeholder: {
                    ProgressView()
                }
                Text(movie.title)
            }
        }.searchable(text: $search)
    }
}

#Preview {
    NavigationStack {
        ContentView(httpClient: HTTPClient())
    }
}
