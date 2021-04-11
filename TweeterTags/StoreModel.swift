//
//  StoreModel.swift
//  TweeterTags
//
//  Created by Ga Jun Young on 2020/3/17.
//  Copyright © 2020 COMP47390-41550. All rights reserved.
//

import Foundation

class StoreModel {
    
    private let defaults = UserDefaults.standard
    private(set) var recentLog: [String] {
        set {
            let serializedLog = newValue.map {"\($0)" }
            defaults.set(serializedLog, forKey: Identifiers.defaultsKey)
            defaults.synchronize()
        }
        get {
            let serializedLog = defaults.object(forKey: Identifiers.defaultsKey) as? [String] ?? []
            return serializedLog
        }
    }
    
    private struct Identifiers {
        static let defaultsKey = "TweetSearch.History"
    }
    
    func addRecentTweet(_ term: String) {
        recentLog.removeDuplicate(newValue: term)
        recentLog.insert(term, at: 0) // insert start of list so it appears on top
        
        if recentLog.count > 100 {
            recentLog.removeLast()
        }
    }
}


extension Array where Element: Hashable {
    /**
     Remove Duplicate element given a newValue
     */
    mutating func removeDuplicate(newValue: Element){
        var result = [Element]()
        
        for value in self {
            if value != newValue { // if not a duplicate, append to results.
                result.append(value)
            }
        }
        
        self = result
    }
}
