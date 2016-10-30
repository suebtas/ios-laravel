//
//  LaravelEndpoint.swift
//  iOS Laravel
//
//  Created by Suebtas on 10/8/2559 BE.
//  Copyright © 2559 Suebtas. All rights reserved.
//

import Foundation

// to create a URLRequest for any clientID, secret, coordinate, endpoint, query...

enum LaravelEndpoint
{
    case search(query: String?, limit: Int?)
    
    var baseURL: String {
        return "http://172.17.1.224:8000"
    }
    
    var path: String {
        switch self {
        case .search: return "/api/all-book"
        }
    }
    
    private struct ParameterKeys {
        static let query = "query"
        static let limit = "limit"
    }
    
    private struct DefaultValues {
        static let limit = "50"
    }
    
    // ["client_id" : "adfa8sdyf80a", "coordinate" : "57.4,85"]
    var parameters: [String : Any] {
        switch self {
        case .search(let query, let limit):
            var parameters : [String : Any] = [
                ParameterKeys.limit : limit
            ]
            
            if let query = query {
                parameters[ParameterKeys.query] = query
            }
            
            return parameters
        }
    }
    
    var queryComponents: [URLQueryItem] {
        var components = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.append(queryItem)
        }
        
        return components
    }
    
    var request: URLRequest {
        var components = URLComponents(string: baseURL)!
        components.path = path
        components.queryItems = queryComponents
        
        let url = components.url!
        return URLRequest(url: url)
    }
}



















