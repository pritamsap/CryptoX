//
//  CoinImageView.swift
//  CryptoX
//
//  Created by pritam on 2024-09-19.
//

import SwiftUI



// Each image will have it's own view
struct CoinImageView: View {
    
    
    @State var vm: CoinImageViewModel
    
    init(coin: CoinModel) {
        _vm = State(wrappedValue: CoinImageViewModel(coin: coin))
    }
    
    var body: some View {
        if let image = vm.image {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
        } else  if vm.isloading {
            ProgressView()
        } else {
            Image(systemName: "questionmark")
                .foregroundStyle(Color.theme.secondaryText)
        }
    }
}

#Preview {
    CoinImageView(coin: DeveloperPreview.instance.coin)
}
