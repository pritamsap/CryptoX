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
    private let fileManager = LocalFileManager.instance
    private let folderName = "coin_image"
    private let imageName : String
    
    init(coin: CoinModel) {
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }
    
    
    
    private func getCoinImage() {
        // This returns optional
        //Check if image exist in save Image
        if let savedImage = fileManager.getImage(imageName: coin.id, folderName: folderName) {
            image = savedImage
            print("Retrieved Image from File Manager!")
        }
        else {
            downloadCoinImage()
            print("Downloading image now")
        }
    }
    
    
    private func downloadCoinImage() {
        print("Downloading image now")
        guard  let url = URL(string: coin.image) else { return }
       
            imageSubscription = NetworkingManager.downloadTwo(url: url)
            .tryMap({ data -> UIImage? in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] returnedImage in
                
                guard let self = self, let downloadedImage = returnedImage else {return }
                self.image = downloadedImage
                self.imageSubscription?.cancel()
                self.fileManager.saveImage(image: downloadedImage, imageName: self.imageName, folderName: self.folderName)
            })
        }
        
}

