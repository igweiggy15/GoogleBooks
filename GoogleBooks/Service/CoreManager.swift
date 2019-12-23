//
//  CoreManager.swift
//  GoogleBooks
//
//
//

import Foundation
import CoreData

typealias BookHandlerCore = ([Book]) -> Void

let core = CoreManager.shared

final class CoreManager {
    
    
    static let shared = CoreManager()
    private init() {}
    
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        var container = NSPersistentContainer(name: "GoogleBooks")
        
        container.loadPersistentStores(completionHandler: { (storeDescrip, err) in
            if let error = err {
                fatalError(error.localizedDescription)
            }
        })
        
        return container
    }()
    
    func read(_ id: String) -> CoreFav? {
        let fetchRequest = NSFetchRequest<CoreFav>(entityName: "CoreFav")
        
        let predicate = NSPredicate(format: "id==%@", id)
        
        fetchRequest.predicate = predicate
        
        var favResult = [CoreFav]()
        
        do {
            favResult = try context.fetch(fetchRequest)
            
            guard let core = favResult.first else { return nil}
            print("Found Book From Core: \(String(describing: core.id))")
            return core
            
        } catch {
            print("Couldn't Fetch Book: \(error.localizedDescription)")
        }
        return nil
    }
    
    //MARK: Save
    func save(_ book: Book) {
        
        let entity = NSEntityDescription.entity(forEntityName: "CoreFav", in: context)!
        let core = CoreFav(entity: entity, insertInto: context)
        
        core.setValue(book.id, forKey: "id")
        core.setValue(book.info?.title, forKey: "title")
        core.setValue(book.info?.subtitle, forKey: "subtitle")
        core.setValue(book.info?.desc, forKey: "bookDescription")
        core.setValue(book.short?.text, forKey: "short")
        core.setValue(book.info?.imgs?.small, forKey: "smallImage")
        core.setValue(book.info?.imgs?.large, forKey: "largeImage")
        core.setValue(toStr(from: book.info?.authors), forKey: "authors")
        core.setValue(book.info?.publishDate, forKey: "publishedDate")
        
        print("Saved Book To Core: \(String(describing: book.info?.title)) \(String(describing: book.id))")
        saveContext()
    }
    
    //MARK: Delete
    func delete(_ book: Book) {
        
        let fetchRequest = NSFetchRequest<CoreFav>(entityName: "CoreFav")
        
        let predicate = NSPredicate(format: "id==%@", book.id)
        
        fetchRequest.predicate = predicate
        
        var favResult = [CoreFav]()
        
        do {
            favResult = try context.fetch(fetchRequest)
            
            guard let core = favResult.first else { return }
            context.delete(core)
            print("Deleted Book From Core: \(String(describing: book.id))")
            
        } catch {
            print("Couldn't Fetch Book: \(error.localizedDescription)")
        }
        
        saveContext()
    }
    
    //MARK: Load
    func load(completion: @escaping BookHandlerCore) {
        
        let fetchRequest = NSFetchRequest<CoreFav>(entityName: "CoreFav")
        
        var books = [Book]()
        
        do {
            let coreBooks = try context.fetch(fetchRequest)
            for core in coreBooks {
                books.append(Book(from: core))
            }
            completion(books)
            return
            
        } catch {
            print("Couldn't Fetch Book: \(error.localizedDescription)")
            completion([])
            return
        }
    }
    
    //MARK: Helpers
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    private func toStr(from: [String]?) -> String? {
        var str: String = ""
        if let fro = from {
            for f in fro {
                str += f + ","
            }
        }
        return str
    }
    
}

