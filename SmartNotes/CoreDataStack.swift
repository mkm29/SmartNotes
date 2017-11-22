//
//  CoreDataStack.swift
//  SmartNotes
//
//  Created by Mitchell Murphy on 7/22/17.
//  Copyright © 2017 Mitchell Murphy. All rights reserved.
//

import CoreData


class CoreDataStack: NSObject {
    
    
    static let shared = CoreDataStack()
    
    
    // MARK: - Core Data stack
    
    var context: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "SmartNotes")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    private func retrieve<T: NSManagedObject>(entity: T.Type,withPredicate predicate: NSPredicate?) -> [T]? {
        var results: [T]?
        
        if let fetchRequest: NSFetchRequest<T> = T.fetchRequest() as? NSFetchRequest<T> {
            if predicate != nil { fetchRequest.predicate = predicate }

            do {
                results = try self.context.fetch(fetchRequest)
            } catch  {
                assert(false, error.localizedDescription)
            }
        } else {
            assert(false,"Error: cast to NSFetchRequest<T> failed")
        }
        
        return results
    }
    
    
    func retrieveUser(withEmail email: String) -> User? {
        // create the Predicate
        let userPredicate = NSPredicate(format: "email = %@", email)
        
        if let users = self.retrieve(entity: User.self, withPredicate: userPredicate) {
            return users.first
        }
        return nil
    }
    
    
    func createUser(fromDictionary userDict: [String:Any]) -> User? {
        guard let email = userDict["email"] as? String else {
            return nil
        }
        
        
        let newUser = User(context: self.context)
        newUser.email = email
        
        
        newUser.firstName = userDict["firstName"] as? String
        newUser.lastName = userDict["lastName"] as? String
        newUser.pictureURL = userDict["pictureURL"] as? String
        
        return newUser
    }
    
    
    
}
