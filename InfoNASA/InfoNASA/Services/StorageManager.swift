//
//  StorageManager.swift
//  InfoNASA
//
//  Created by Станислав Буйновский on 04.12.2021.
//
//
//  StorageManager.swift
//  RealmApp
//
//  Created by Alexey Efimov on 08.10.2021.
//  Copyright © 2021 Alexey Efimov. All rights reserved.
//

import RealmSwift

protocol StorageManagerProtocol {
    func save<T: Object>(_ object: T)
    func save<T: Object>(_ objects: [T])
    func delete<T: Object>(_ object: T)
}

class StorageManager: StorageManagerProtocol {
    
    static let shared = StorageManager()
    
    let realm = try! Realm()
    
    private init() {}

    // MARK: - Main actions
    func save<T: Object>(_ object: T) {
        write {
            realm.add(object, update: .modified)
        }
    }
    
    func save<T: Object>(_ objects: [T]) {
        write {
            realm.add(objects, update: .modified)
        }
    }
    
    func delete<T: Object>(_ object: T) {
        write {
            realm.delete(object)
        }
    }
    
    private func write(completion: () -> Void) {
        do {
            try realm.write {
                completion()
            }
        } catch {
            print(error)
        }
    }
}
