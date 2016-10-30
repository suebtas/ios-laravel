//
//  LocalStore.swift
//  DNApp
//
//  Created by Meng To on 2015-03-10.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit

struct LocalStore {
    
    static let userDefaults = UserDefaults.standard
    
    static func saveToken(_ token: String) {
        userDefaults.set(token, forKey: "tokenKey")
    }
    
    static func getToken() -> String? {
        return userDefaults.string(forKey: "tokenKey")
    }
    
    static func deleteToken() {
        userDefaults.removeObject(forKey: "tokenKey")
    }
    
    static func saveUpvotedStory(_ storyId: Int) {
        appendId(storyId, toKey: "upvotedStoriesKey")
    }
    
    static func saveUpvotedComment(_ commentId: Int) {
        appendId(commentId, toKey: "upvotedCommentsKey")
    }
    
    static func isStoryUpvoted(_ storyId: Int) -> Bool {
        return arrayForKey("upvotedStoriesKey", containsId: storyId)
    }
    
    static func isCommentUpvoted(_ commentId: Int) -> Bool {
        return arrayForKey("upvotedCommentsKey", containsId: commentId)
    }
    
    // MARK: Helper

    fileprivate static func arrayForKey(_ key: String, containsId id: Int) -> Bool {
        let elements = userDefaults.array(forKey: key) as? [Int] ?? []
        return elements.contains(id)
    }

    fileprivate static func appendId(_ id: Int, toKey key: String) {
        let elements = userDefaults.array(forKey: key) as? [Int] ?? []
        if !elements.contains(id) {
            userDefaults.set(elements + [id], forKey: key)
        }
    }
}
