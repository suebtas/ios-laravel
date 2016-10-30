//
//  FoursquareClient.swift
//  VenueExplorer
//
//  Created by Duc Tran on 8/28/16.
//  Copyright © 2016 Developers Academy. All rights reserved.
//

import Foundation

class FoursquareClient
{
    let clientID: String
    let clientSecret: String
    
    init(clientID: String, clientSecret: String)
    {
        self.clientSecret = clientSecret
        self.clientID = clientID
    }
    
    func fetchVenuesFor(coordinate: Coordinate, query: String? = nil, searchRadius: Int? = nil, completion: @escaping (APIResult<[Venue]>) -> Void)
    {
        let searchEndpoint = FoursquareEndpoint.search(clientID: clientID, clientSecret: clientSecret, coordinate: coordinate, query: query, searchRadius: searchRadius)
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
                
                guard let response = json["response"] as? [String : Any],
                    let venueDictionaries = response["venues"] as? [[String : Any]] else {
                        let error = NSError(domain: DANetworkingErrorDomain, code: UnexpectedResponseError, userInfo: nil)
                        completion(.failure(error))
                        return
                }
                
                // (3) completion
                let venues = venueDictionaries.flatMap { venueDict in
                    return Venue(json: venueDict)
                }
                
                completion(.success(venues))
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
}





































