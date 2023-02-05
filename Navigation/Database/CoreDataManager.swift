//
//  CoreDataManager.swift
//  Navigation
//
//  Created by Александр Востриков on 25.12.2022.
//

import CoreData
import StorageService

final class CoreDataManager {
    
    static let dataManager = CoreDataManager()
    
    var posts: [PostCoreData] = []
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constants.dataModel)
        container.loadPersistentStores(completionHandler: { storeDescription, error in
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
    
    private func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate.
                //You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    private init (){
        loadData()
    }
    
    func loadData(){
        let fetchRequest = PostCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "data", ascending: true)]
        
        do {
            let postFetched = try persistentContainer.viewContext.fetch(fetchRequest)
            posts = postFetched
        } catch {
            print(error.localizedDescription)
            posts = []
        }
    }
    
    func addPost(post: Post){
        let postCoreData = PostCoreData(context: persistentContainer.viewContext)
        postCoreData.author = post.author
        postCoreData.descriptionPost = post.description
        postCoreData.image = post.image
        postCoreData.views = Int64(post.views)
        postCoreData.likes = Int64(post.likes)
        saveContext()
        loadData()
    }
}
