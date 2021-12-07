//
//  StorageManager.swift
//  InfoNASA
//
//  Created by Станислав Буйновский on 04.12.2021.
//

//
//  StorageManager.swift
//  UIAdaptivePresentation
//
//  Created by Alexey Efimov on 02.12.2021.
//  Copyright © 2021 Alexey Efimov. All rights reserved.
//

import Foundation

protocol StorageManagerProtocol {
//    func save<T>(object: T, for key: StorageKeys)
    func save<T>(objects: [String: [T]], for key: StorageKeys)
    func getObjects<T>(for key: StorageKeys) -> [String: [T]]
    func deleteObjects(for key: StorageKeys)
}

enum StorageKeys: String {
    case picturesOfDay
    case nearEarthObjects
    case picturesOfEPIC
}

class StorageManager: StorageManagerProtocol {
    
    static let shared = StorageManager()
    
    private let userDefaults = UserDefaults.standard
    
    private init() {}
    
//    func save<T>(object: T, for key: StorageKeys) {
//        var objects: [String: [T]] = getObjects(for: key)
//        objects.append(object)
//        save(objects: objects, for: key)
//    }
    
    func save<T>(objects: [String: [T]], for key: StorageKeys) {
        userDefaults.set(objects, forKey: key.rawValue)
        
    }
    
    func getObjects<T>(for key: StorageKeys) -> [String: [T]] {
        if let objects = userDefaults.value(forKey: key.rawValue) as? [String: [T]] {
            return objects
        }
        return [:]
    }
    
    func deleteObjects(for key: StorageKeys) {
        userDefaults.removeObject(forKey: key.rawValue)
    }
}

