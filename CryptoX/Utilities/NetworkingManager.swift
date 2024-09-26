//
//  NetworkingManager.swift
//  CryptoX
//
//  Created by pritam on 2024-09-19.
//

import Foundation
import Combine

class NetworkingManager {
    
    enum NetworkingError: LocalizedError {
        case badURLResponse(url: URL)
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badURLResponse(url: let url):
               return "Bad Response from URL: \(url)"
            case .unknown:
              return   "Unknown error occured"
            }
        }
    }
    
    // By creating a static func we do not need to initialize the class for request
    static func download(request: URLRequest) ->
    AnyPublisher<Data, any Error>
    {
        
    guard let url = request.url else {
                return Fail(error: NetworkingError.badURLResponse(url: URL(string: "Invalid URL")!))
                    .eraseToAnyPublisher()
        }
            
       return URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap({ try handleURLResponse(output: $0, url: url) })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // By creating a static func we do not need to initialize the class for url
    static func downloadTwo(url: URL) ->
    AnyPublisher<Data, any Error>
    {
       return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap({ try handleURLResponse(output: $0, url: url) })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
                response.statusCode >= 200 && response.statusCode <= 300 else {
            throw NetworkingError.badURLResponse(url: url)
        }
        return output.data
    }
    
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
            case .finished:
                break
            case .failure(let error):
            print(completion)
            print(error.localizedDescription)
        }
    }
    
    
    
}
