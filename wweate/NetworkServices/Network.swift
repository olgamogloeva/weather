//
//  Network.swift
//  wweate
//
//  Created by Olga Mogloeva on 24.03.2024.
//

import Foundation

final class Network {
    
    func fetchData<T: Decodable>(from url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NoDataError()))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

struct NoDataError: Error {
    
}

enum MyError: Error {
    case runtimeError(String)
}
