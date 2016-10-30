//
//  Coordinate.swift
//  VenueExplorer
//
//  Created by Duc Tran on 8/27/16.
//  Copyright © 2016 Developers Academy. All rights reserved.
//

import Foundation

struct Coordinate : CustomStringConvertible {
    let latitude: Double
    let longitude: Double
    
    var description: String {
        return "\(latitude),\(longitude)"
    }
}
