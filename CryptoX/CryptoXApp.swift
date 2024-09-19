//
//  CryptoXApp.swift
//  CryptoX
//
//  Created by pritam on 2024-09-17.
//

import SwiftUI

@main
struct CryptoXApp: App {
    @State private var vm = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView()
                    .toolbar(.hidden)
            }
            .environment(vm)
        }
    }
}
