//
//  UserDefaultManager.swift
//  Todos
//
//  Created by Abdelrhman Ahmed on 29/04/2022.
//

import Foundation

class UserDefaultManager {
    
    let userDefaults = UserDefaults(suiteName: "com.example.todos.data")
    static let shared = UserDefaultManager()
    
    func getFilter() -> Int{
        
        if let filter = userDefaults?.value(forKey: "filter") as? Int {
            return filter
        } else {
            return 0
        }
        
    }
    
    func saveFilter(filter: Int) {
        userDefaults?.setValue(filter, forKey: "filter")
    }

    func getIfSort() -> Bool{

        if let sort = userDefaults?.value(forKey: "sort") as? Bool {
            return sort
        } else {
            return false
        }

    }

    func saveIfSort(sort: Bool) {
        userDefaults?.setValue(sort, forKey: "sort")
    }
    
}
