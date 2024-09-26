//
//  StatisticModel.swift
//  CryptoX
//
//  Created by pritam on 2024-09-22.
//

import Foundation


struct StatisticModel: Identifiable {
    
    let id = UUID().uuidString
    let title: String
    let value: String
    let percentageChange: Double?
    
    init(title: String, value: String, percentageChange: Double? = nil) {
        self.title = title
        self.value = value
        self.percentageChange = percentageChange
    }
}


let newModel = StatisticModel(title: "", value: "", percentageChange: nil)
let newModel2 = StatisticModel(title: "Cap", value: "Tap")
