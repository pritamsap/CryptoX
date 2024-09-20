//
//  CoinImageService.swift
//  CryptoX
//
//  Created by pritam on 2024-09-19.
//

import Foundation
import SwiftUI
import Combine

class CoinImageService {
    
    @Published var image: UIImage? = nil
    
    private var imageSubscription: AnyCancellable?
    private let coin: CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
        getCoinImage()
    }
    private func getCoinImage() {
        guard  let url = URL(string: coin.image) else { return }
       
            imageSubscription = NetworkingManager.downloadTwo(url: url)
            .tryMap({ data -> UIImage? in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] returnedIMage in
                self?.image = returnedIMage
                self?.imageSubscription?.cancel()
            })
        }
        
}

