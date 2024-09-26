//
//  CoinDataService.swift
//  CryptoX
//
//  Created by pritam on 2024-09-23.
//

import Foundation
import Combine

class MarketDataService {
    
    
    @Published var marketData: MarketDataModel? = nil
    var marketDataSubscription: AnyCancellable?
    
    init() {
        getMarketData()
    }
    
    
    private func getMarketData() {
        guard  let url = URL(string: "https://api.coingecko.com/api/v3/global") else { return }
    
            
        //print("request is: \(request)" )
        marketDataSubscription = NetworkingManager.downloadTwo(url: url)
                .decode(type: GlobalDataModel.self, decoder: JSONDecoder())
                .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] returnedGlobalData in
                    self?.marketData =  returnedGlobalData.data
                    self?.marketDataSubscription?.cancel()
                })
    }
}
