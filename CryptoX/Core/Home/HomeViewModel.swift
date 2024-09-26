//
//  HomeViewModel.swift
//  CryptoX
//
//  Created by pritam on 2024-09-19.
//

import Foundation
import Combine


@Observable class HomeViewModel {
    

    
    var statistics: [StatisticModel] = []
    
    
     var allCoins: [CoinModel] = []
     var portfolioCoins: [CoinModel] = []
        
    var searchText: String = "" {
           didSet {
               searchTextSubject.send(searchText) // Manually send searchText changes
           }
       }
       
    // Create a PassthroughSubject to act as a Combine publisher for searchText
        private let searchTextSubject = PassthroughSubject<String, Never>()
        

    
    
    private let coinDataService = CoinDataService()
    private let marketDataSerivce = MarketDataService()
    
    private var cancellables = Set<AnyCancellable>()

    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        
        // Does the same subscribing as below so we don't need it
//        dataService.$allCoins
//            .sink { [weak self] returnedCoins in
//                self?.allCoins = returnedCoins
//            }
//            .store(in: &cancellables)
            
        
        // Update All Coins
        searchTextSubject
            .combineLatest(coinDataService.$allCoins)
        
        // Debounce will wait 0.5 before running the code
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        
        
        
        /**
         Updates the Market Data
         */
        // Convert MarketDataModel into statistic Model
        marketDataSerivce.$marketData
        
        
            .map(mapGlobalMarketData)
            .sink { [weak self] returnedStats in
                self?.statistics = returnedStats
            }
            .store(in: &cancellables)
     
            
    }
    
    
    private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
           guard !text.isEmpty else {
               // just the starting original coins - no change
               return coins
           }
           let lowercasedText = text.lowercased()
           
           return coins.filter { coin -> Bool in
               return coin.name.lowercased().contains(lowercasedText) ||
               coin.symbol.lowercased().contains(lowercasedText)
               || coin.symbol.lowercased().contains(lowercasedText)
           }
    }
    
    
    private func mapGlobalMarketData(marketDataModel: MarketDataModel?) -> [StatisticModel] {
        var stats: [StatisticModel] = []
        
        guard let data = marketDataModel else {
            return stats
        }
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        let portfolio = StatisticModel(title: "Portfolio Value", value: "$0.00", percentageChange: 0)
        
        stats.append(contentsOf: [marketCap, volume, btcDominance, portfolio])
        return stats
    }
}

