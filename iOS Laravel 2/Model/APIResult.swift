//
//  APIResult.swift
//  VenueExplorer
//
//  Created by Duc Tran on 8/28/16.
//  Copyright © 2016 Developers Academy. All rights reserved.
//

import Foundation

enum APIResult<T> {
    case success(T)  // it has data!!! but of different types
    case failure(Error)
}

