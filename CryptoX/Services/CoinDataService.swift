//
//  CoinDataService.swift
//  CryptoX
//
//  Created by pritam on 2024-09-19.
//

import Foundation
import Combine

class CoinDataService {
    
    
    @Published var allCoins: [CoinModel] = []
    var coinSubscription: AnyCancellable?
    
    init() {
        getCoins()
    }
    
    
    private func getCoins() {
        guard  let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets") else { return }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        let queryItems: [URLQueryItem] = [
          URLQueryItem(name: "vs_currency", value: "usd"),
          URLQueryItem(name: "per_page", value: "250"),
          URLQueryItem(name: "page", value: "1"),
          URLQueryItem(name: "sparkline", value: "true"),
          URLQueryItem(name: "price_change_percentage", value: "24h"),
        ]
        components?.queryItems = queryItems
        
        if let finalURL = components?.url {
            var request = URLRequest(url: finalURL)
            request.httpMethod = "GET"
            
              var apiKey: String {
                   guard let filePath = Bundle.main.path(forResource: "keys", ofType: "plist"),
                         let plist = NSDictionary(contentsOfFile: filePath),
                         let value = plist["gecko_key"] as? String else {
                       fatalError("Couldn't find key 'gecko_key'.")
                   }
                   return value
               }
            
            request.allHTTPHeaderFields = [
              "accept": "application/json",
              "api-key": apiKey
            ]
            
            coinSubscription = NetworkingManager.download(request: request)
                .decode(type: [CoinModel].self, decoder: JSONDecoder())
                .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] returnedCoins in
                    self?.allCoins = returnedCoins
                    self?.coinSubscription?.cancel()
                })
        }

      
        
        
    }
}
