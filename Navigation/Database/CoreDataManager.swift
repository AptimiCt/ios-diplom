//
//  CoreDataManager.swift
//  Navigation
//
//  Created by Александр Востриков on 25.12.2022.
//

import CoreData
import StorageService

enum DatabaseError: Error {
    /// Невозможно добавить хранилище.
    case store(model: String)
    /// Не найден momd файл.
    case find(model: String, bundle: Bundle?)
    /// Дубликат поста есть в базе
    case dublicate
    /// Не найдена модель объекта.
    case wrongModel
    /// Кастомная ошибка.
    case error(desription: String)
    /// Неизвестная ошибка.
    case unknown(error: Error)
}

final class CoreDataManager {
    
    static let dataManager = CoreDataManager()
    
    var posts: [PostCoreData] = []
    
    private enum CompletionHandlerType {
        case success
        case failure(error: DatabaseError)
    }
    
    private let persistentStoreCoordinator: NSPersistentStoreCoordinator
    
    private lazy var saveContext: NSManagedObjectContext = {
        let saveContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        saveContext.parent = self.mainContext
        saveContext.mergePolicy = NSOverwriteMergePolicy
        return saveContext
    }()
    private lazy var mainContext: NSManagedObjectContext = {
        let mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainContext.parent = self.masterContext
        mainContext.mergePolicy = NSOverwriteMergePolicy
        return mainContext
    }()
    private lazy var masterContext: NSManagedObjectContext = {
        let masterContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        masterContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        masterContext.mergePolicy = NSOverwriteMergePolicy
        return masterContext
    }()
    
    private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constants.dataModel)
        container.loadPersistentStores(completionHandler: { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private init () {
        self.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
    }
    
    private func save(with context: NSManagedObjectContext,
                      completionHandler: (()->Void)? = nil,
                      failureCompletion: ((DatabaseError) -> Void)? = nil) {
        guard context.hasChanges else {
            if context.parent != nil {
                print("context.hasChanges:\(context.hasChanges)")
                self.handler(for: .failure(error: .error(desription: "Context has not changes")),
                             using: context, contextWorksInOwnQueue: false,
                             with: completionHandler,
                             and: failureCompletion)
            }
            return
        }
        context.perform {
            do {
                try context.save()
            } catch let error {
                self.handler(for: .failure(error: .error(desription: "Unable to save changes of context.\nError - \(error.localizedDescription)")),
                             using: context, contextWorksInOwnQueue: false,
                             with: completionHandler,
                             and: failureCompletion)
            }
            
            guard let parentContext = context.parent else { return }
            self.handler(for: .success, using: context, with: completionHandler, and: failureCompletion)
            self.save(with: parentContext, completionHandler: completionHandler, failureCompletion: failureCompletion)
        }
    }
    
    private func handler(for type: CompletionHandlerType,
                         using context: NSManagedObjectContext,
                         contextWorksInOwnQueue: Bool = true,
                         with completionHandler: (() -> Void)?,
                         and failureCompletion: ((DatabaseError) -> Void)?) {
        switch type {
            case .success:
                if context.concurrencyType == .mainQueueConcurrencyType {
                    if contextWorksInOwnQueue {
                        completionHandler?()
                    } else {
                        self.mainContext.perform {
                            completionHandler?()
                        }
                    }
                }
            case .failure(let error):
                if context.concurrencyType == .mainQueueConcurrencyType {
                    if contextWorksInOwnQueue {
                        failureCompletion?(error)
                    } else {
                        self.mainContext.perform {
                            failureCompletion?(error)
                        }
                    }
                }
        }
    }
    
    private func configure(model: PostCoreData, from post: Post) {
        model.identifier = Int64(post.id)
        model.author = post.author
        model.descriptionPost = post.description
        model.image = post.image
        model.views = Int64(post.views)
        model.likes = Int64(post.likes)
    }
}

extension CoreDataManager {
    
    func create(post: Post, completion: @escaping (Result<PostCoreData?, DatabaseError>)->Void) {
        let predicate = NSPredicate(format: "identifier == \(Int64(post.id))")
        fetch(predicate: predicate) { result in
            switch result {
                case .success(let data):
                    self.saveContext.perform {
                        if data.isEmpty {
                            let postCoreData = PostCoreData(context: self.saveContext)
                            self.configure(model: postCoreData, from: post)
                            self.save(with: self.saveContext, completionHandler: { completion(.success(postCoreData)) })
                        } else {
                            self.mainContext.perform {
                                completion(.failure(.dublicate))
                            }
                            
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    break
            }
        }
    }
    
    func fetch(predicate: NSPredicate?, completion: @escaping (Result<[PostCoreData], DatabaseError>) -> Void) {
        saveContext.perform {
            let request = PostCoreData.fetchRequest()
            request.predicate = predicate
            guard let result = try? self.saveContext.fetch(request)
            else {
                self.mainContext.perform {
                    completion(.failure(.wrongModel))
                }
                return
            }
            self.mainContext.perform {
                self.posts = result
                completion(.success(result))
            }
        }
    }
    
    func delete(predicate: NSPredicate, completion: @escaping (Result<[PostCoreData], DatabaseError>) -> Void) {
        fetch(predicate: predicate) { [weak self] result in
            guard let self else { return }
            switch result {
                case .success(let fetchedObjects):
                    guard !fetchedObjects.isEmpty else {
                        completion(.failure(.wrongModel))
                        return
                    }
                    self.saveContext.perform {
                        fetchedObjects.forEach { fetchOject in
                            self.saveContext.delete(fetchOject)
                        }
                        self.save(with: self.saveContext, completionHandler: { completion(.success(fetchedObjects)) }, failureCompletion: { error in completion(.failure(error))
                        })
                    }
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
}
