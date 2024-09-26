//
//  MarketDataModel.swift
//  CryptoX
//
//  Created by pritam on 2024-09-23.
//


/*
 JSON Data
 URL : "https://api.coingecko.com/api/v3/global"
 
 {
   "data": {
     "active_cryptocurrencies": 14668,
     "upcoming_icos": 0,
     "ongoing_icos": 49,
     "ended_icos": 3376,
     "markets": 1199,
     "total_market_cap": {
       "btc": 36756885.08919883,
       "eth": 877552158.7576463,
       "sats": 3675688508919883
     },
     "total_volume": {
       "btc": 1552033.3610342485,
       "sats": 155203336103424.84
     },
     "market_cap_percentage": {
       "btc": 53.75334903842487,
     },
     "market_cap_change_percentage_24h_usd": -0.3082512846562129,
     "updated_at": 1727132771
   }
 }
 
 */

import Foundation


// MARK: - Welcome
struct GlobalDataModel: Codable {
    let data: MarketDataModel?
}

// MARK: - DataClass
struct MarketDataModel: Codable {
    let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]
    let marketCapChangePercentage24HUsd: Double
    
    
    enum CodingKeys: String, CodingKey {
        case totalMarketCap = "total_market_cap"
        case totalVolume = "total_volume"
        case marketCapPercentage = "market_cap_percentage"
        case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"
    }
    
    
    var marketCap: String {
        if let item = totalMarketCap.first(where: {$0.key == "usd"}) {
            return "$" + item.value.formattedWithAbbreviations()
        }
        return ""
    }
    
    var volume: String {
        if let item = totalVolume.first(where: { $0.key == "usd" }) {
            return "$" + item.value.formattedWithAbbreviations()
        }
        return ""
    }
    
    var btcDominance: String {
        if let item = marketCapPercentage.first(where: { $0.key == "btc"}) {
            return item.value.asPercentString()
        }
        return ""
    }
}
