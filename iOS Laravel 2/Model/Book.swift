//
//  Book.swift
//  iOS Laravel
//
//  Created by Suebtas on 10/8/2559 BE.
//  Copyright © 2559 Suebtas. All rights reserved.
//

import Foundation

struct Book
{
    let id: Int
    let title: String
    let author_name: String
    let pages_count: String
    let user_id: String
    let created_at: String
    let updated_at: String
    
    init?(json: [String : Any])
    {
        guard let id = json["id"] as? Int,
            let title = json["title"] as? String,
            let author_name = json["author_name"] as? String,
            let page_count = json["pages_count"] as? String,
            let user_id = json["user_id"] as? String,
            let created_at = json["created_at"] as? String,
            let updated_at = json["updated_at"] as? String else {
            return nil
        }
        
        self.id = id
        self.title = title
        self.author_name = author_name
        self.pages_count = page_count
        self.user_id = user_id
        self.created_at = created_at
        self.updated_at = updated_at
    }
}















