//
//  PortfolioDataService.swift
//  CryptoX
//
//  Created by pritam on 2024-09-30.
//

import Foundation
import CoreData

class PortfolioDataService {
    
    
    private let container: NSPersistentContainer
    private let containerName: String = "PortfolioContainer"
    private let portfolioEntity: String = "PortfolioEntity"
    
    @Published var savedEntites: [PortfolioEntity] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Error loading Core data \(error)")
            }
            self.getPortfolio()
        }
    }
    
    
    // MARK: PUBLIC
    func updatePortfolio(coin: CoinModel, amount: Double) {
           
        
        // Check if coin pre exist in portfolio
        if let entity = savedEntites.first(where: { savedEntity in
            return savedEntity.coinID == coin.id
        }) {
            if amount > 0 {
                update(entity: entity, newAmount: amount)
            }else {
                delete(entity: entity)
            }
        }
        
        else {
            add(coin: coin, amount: amount)
        }
    }
    
    
    
    
    
    
    
    // MARK: PRIVATE
    private func getPortfolio() {
        let request = NSFetchRequest<PortfolioEntity>(entityName: portfolioEntity)
        do {
          savedEntites = try container.viewContext.fetch(request)
        } catch let error  {
            print("Error fetching portfolio entity \(error)")
        }
    }
    
    private func add(coin: CoinModel, amount: Double) {
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        applyChanges()
    }
    
    private func update(entity: PortfolioEntity, newAmount: Double) {
        entity.amount = newAmount
        applyChanges()
    }
    
    private func delete(entity: PortfolioEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch let error  {
            print("Error saving to core data \(error)")
        }
    }
    
    
    private func applyChanges() {
        save()
        getPortfolio()
    }
    
    
    
    
}
