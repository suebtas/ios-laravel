//
//  LaravelClient.swift
//  iOS Laravel Navigator
//
//  Created by Suebtas Limsaihua on 10/24/16.
//  Copyright © 2016 Mahanakorn University of Technology. All rights reserved.
//

import Foundation

class LaravelClient
{
    let clientID: String
    let clientSecret: String
    
    init(clientID: String, clientSecret: String)
    {
        self.clientSecret = clientSecret
        self.clientID = clientID
    }
    
    func fetchBookFor(query: String? = nil, limit: Int? = nil, completion: @escaping (APIResult<[Book]>) -> Void)
    {
        let searchEndpoint = LaravelEndpoint.search(query: query, limit: limit)
        let networkProcessing = NetworkProcessing(request: searchEndpoint.request)
        
        networkProcessing.downloadJSON { (json, httpResponse, error) in
            // OFF the main thread!!!!!!! UI code must be on the main thread!!
            // TODOs:
            // (1) get back to the main thread
            DispatchQueue.main.async {
                // (2) from json turn into [Venue]
                guard let json = json else {
                    if let error = error {
                        completion(.failure(error))
                    }
                    
                    return
                }
                
                guard let bookDictionaries = json["books"] as? [[String : Any]] else {
                        let error = NSError(domain: DANetworkingErrorDomain, code: UnexpectedResponseError, userInfo: nil)
                        completion(.failure(error))
                    return
                }
            
                // (3) completion
                
                let books = bookDictionaries.flatMap { bookDict in
                    return Book(json: bookDict)
                }
                
                completion(.success(books))
            }
        }
    }
    
    func fetchData(url: URL, completion: @escaping (APIResult<Data>) -> Void)
    {
        let request = URLRequest(url: url)
        let networkProcessing = NetworkProcessing(request: request)
        networkProcessing.downloadData { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else if let data = data {
                    completion(.success(data))
                }
            }
        }
    }
    
    func makeAuth(_ username: String, _ password: String, completion: @escaping (APIResult<String>) -> Void){
        let username = username
        let password = password
        
        let baseURL = "http://172.17.1.224:8000/"
        let path = "api/auth/login"
        let urlString = "\(baseURL)\(path)"
        let postString = "password=\(password)&email=\(username)"
        
        let url = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "Post"
        urlRequest.httpBody = postString.data(using: .utf8)
        
        let networkProcessing = NetworkProcessing(request: urlRequest)
        
        networkProcessing.downloadJSON { (json, httpResponse, error) in
            if let dictionary = json {
                if let tokenValue = dictionary["token"] as? String {
                    print(tokenValue)
                    LocalStore.saveToken(tokenValue)
                    
                    completion(.success(tokenValue))
                    //self.performSelector(onMainThread: #selector(ViewController.updateTokenLabel(_:)),with: tokenValue, waitUntilDone: false)
                }
            }
        }
    }
}

