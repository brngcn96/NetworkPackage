//
//  SimpleNetworking.swift
//
//  Created by Baran Göcen 21.08.2024.
//

import Foundation

public enum NetworkError: Error {
    case badRequest
    case decodingError
}

public class Webservice {
    
    private static var _instance: Webservice?
    
    public class var shared: Webservice {
        if _instance == nil {
            _instance = Webservice()
        }
        return _instance!
    }
    
    
    public init() { }
    
    public func fetch<T: Codable>(url: URL, parse: @escaping (Data) -> T?, completion: @escaping (Result<T?, NetworkError>) -> Void)  {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil,
                  (response as? HTTPURLResponse)?.statusCode == 200
            else {
                completion(.failure(.decodingError))
                return
            }
            let result = parse(data)
            completion(.success(result))
            
        }.resume()
        
    }
    
}
