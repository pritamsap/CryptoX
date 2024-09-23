//
//  HomeViewModel.swift
//  CryptoX
//
//  Created by pritam on 2024-09-19.
//

import Foundation
import Combine


@Observable class HomeViewModel {
     var allCoins: [CoinModel] = []
     var portfolioCoins: [CoinModel] = []
        
    var searchText: String = "" {
           didSet {
               searchTextSubject.send(searchText) // Manually send searchText changes
           }
       }
       
    // Create a PassthroughSubject to act as a Combine publisher for searchText
        private let searchTextSubject = PassthroughSubject<String, Never>()
        

    
    
    private let dataService = CoinDataService()
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
            .combineLatest(dataService.$allCoins)
        
        // Debounce will wait 0.5 before running the code
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
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
}

