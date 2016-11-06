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
    case searchBook(query: String?, limit: Int?, token: String?)
    case makeAuth(username: String,  password: String)
    
    var baseURL: String {
        return "http://172.17.1.123:8000"
    }
    
    var path: String {
        switch self {
        case .search: return "/api/all-book"
        case .makeAuth: return "/api/auth/login"
        case .searchBook: return "/api/books"
        }
    }
    
    private struct ParameterKeys {
        static let query = "query"
        static let limit = "limit"
        static let username = "email"
        static let password = "password"
        static let token = "token"
    }
    
    private struct DefaultValues {
        static let limit = "50"
    }
    
    // ["client_id" : "adfa8sdyf80a", "coordinate" : "57.4,85"]
    var parameters: [String : Any] {
        switch self {
        case .searchBook(let query, let limit, let token):
            
            var parameters : [String : Any] = [
                ParameterKeys.token : token! as String
            ]
            
            if let query = query {
                parameters[ParameterKeys.query] = query
            }
            
            return parameters

        case .search(let query, let limit):
            var parameters : [String : Any] = [
                ParameterKeys.limit : limit
            ]
            
            if let query = query {
                parameters[ParameterKeys.query] = query
            }
            
            return parameters
        case .makeAuth(let username,let password):
            let parameters : [String: Any] = [
                ParameterKeys.username : username,
                ParameterKeys.password : password
            ]            
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
        switch self {
        case .searchBook:
            var components = URLComponents(string: baseURL)!
            components.path = path
            components.queryItems = queryComponents
            let url = components.url!
            let request = URLRequest(url: url)
            return request
        case .search:
            var components = URLComponents(string: baseURL)!
            components.path = path
            components.queryItems = queryComponents
            let url = components.url!
            let request = URLRequest(url: url)
            return request
        case .makeAuth:
            var components = URLComponents(string: baseURL)!
            components.path = path
            components.queryItems = queryComponents
            
            let urlString = "\(baseURL)\(path)"
            let url = URL(string: urlString)!
            var request = URLRequest(url: url)
            request.httpMethod = "Post"
            request.httpBody = components.query?.data(using: .utf8)
            return request
        }
    }
}



















