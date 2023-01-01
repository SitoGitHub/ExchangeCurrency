//
//  API.swift
//  ExchangeApp
//
//  Created by Dana on 01/11/2022.
//  Copyright © 2022 Sito. All rights reserved.
//


import Foundation

protocol APIServiceProtocol {
    func fetchData<T: Decodable>(urlString: String, completion: @escaping (Result<T,Error>) -> Void)
}

final class APIService :  NSObject {
    
}
extension APIService: APIServiceProtocol {
    
    func fetchData<T: Decodable>(urlString: String, completion: @escaping (Result<T,Error>) -> Void) {
        guard let url = URL(string: urlString) else { return } 
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            if let error = error { completion(.failure(error)); return }
            if  let rateDataParsing = try? decoder.decode(T.self, from: data){
                completion( Result{rateDataParsing})
            }
        }.resume()
    }
}
