//
//  StorageManager.swift
//  InfoNASA
//
//  Created by Станислав Буйновский on 04.12.2021.
//

//import UIKit
//import CoreData
//
//protocol StorageManagerProtocol {
//    func fetchData<T: NSManagedObject>() -> [T]
//    func getFromContext<T: NSManagedObject>() -> T
//    func delete<T: NSManagedObject>(_ object: T)
//    func updateContext()
//}
//
//class StorageManager: StorageManagerProtocol {
//
//    static var shared = StorageManager()
//    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//
//    private init() {}
//
//    func fetchData<T: NSManagedObject>() -> [T] {
//        let fetchRequest = T.fetchRequest()
//
//        do {
//            return try context.fetch(fetchRequest) as? [T] ?? []
//        } catch {
//            print(error.localizedDescription)
//        }
//
//        return []
//    }
//
//    func getFromContext<T: NSManagedObject>() -> T {
//        let object = T(context: context)
//        return object
//    }
//
//    func delete<T: NSManagedObject>(_ object: T) {
//        context.delete(object)
//        updateContext()
//    }
//
//    func updateContext() {
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch let error {
//                print(error)
//            }
//        }
//    }
//}
