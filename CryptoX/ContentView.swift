//
//  ContentView.swift
//  CryptoX
//
//  Created by pritam on 2024-09-17.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            ZStack {
                Color.theme.background.ignoresSafeArea()
                
                VStack {
                    Text("Accent Color")
                        .foregroundStyle(Color.theme.accent)
                    
                    Text("Secondary Text Color")
                        .foregroundStyle(Color.theme.secondaryText)

                    
                    Text("Red Color")
                        .foregroundStyle(Color.theme.red)

                    
                    Text("Green Color")
                        .foregroundStyle(Color.theme.green)

                }.font(.headline)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
