//
//  ContentView.swift
//  GraphQL
//
//  Created by josh on 2020/03/10.
//

import Apollo

class Network {
    static let shared = Network()
    private(set) lazy var apollo = ApolloClient(url: URL(string: "https://n1kqy.sse.codesandbox.io/")!)
}

import SwiftUI

struct ContentView: View {
    @State var launches: [LaunchListQuery.Data.Launch.Launch] = []

    var body: some View {
        NavigationView {
            Group {
                if launches.isEmpty {
                    Text("Loading")
                } else {
                    List(launches, id: \LaunchListQuery.Data.Launch.Launch.site) { launch in
                        Text("🚀 " + (launch.site ?? "-"))
                    }
                }
            }
            .navigationBarTitle("Launch Sites")
        }
        .onAppear {
            Network.shared.apollo.fetch(query: LaunchListQuery()) { result in
                switch result {
                case .success(let graphQLResult):
                    let l = graphQLResult.data?.launches.launches ?? []
                    self.launches = l.compactMap { $0 }

                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
