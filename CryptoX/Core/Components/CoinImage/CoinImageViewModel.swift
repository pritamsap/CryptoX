//
//  CoinImageViewModel.swift
//  CryptoX
//
//  Created by pritam on 2024-09-20.
//

import Foundation
import SwiftUI
import Combine

@Observable class CoinImageViewModel {
    var image: UIImage? = nil
    var isloading: Bool = false
    
    private let coin: CoinModel
    private let dataService: CoinImageService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        self.coin = coin
        self.dataService = CoinImageService(coin: coin)
        self.addSubscribers()
        self.isloading = true
    }
    
    private func addSubscribers() {
        dataService.$image
            .sink { [weak self] _ in
                self?.isloading = false
            } receiveValue: { [weak self] returnedImage in
                self?.image = returnedImage
            }
            .store(in: &cancellables)

    }
}
