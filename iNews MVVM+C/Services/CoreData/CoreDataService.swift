//
//  CoreDataService.swift
//  iNews MVVM+C
//
//  Created by Слава on 24.07.2024.
//

import CoreData
import UIKit

class CoreDataService {
    static let shared = CoreDataService()
    private let persistentContainer: NSPersistentContainer
    
     init() {
        persistentContainer = NSPersistentContainer(name: "ModelCoreData")
        persistentContainer.loadPersistentStores { description , error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            } else {
//                print("DB url - ", description.url?.absoluteString ?? "I can't find the way to the database")
            }
        }
    }

    //MARK: - CREATE
    
    func createItem(title: String, description: String, pubDate: Date, imageUrl: String, source: String, link: String) {
        let context = persistentContainer.viewContext
        
        // Check for existing URL
        let fetchRequest: NSFetchRequest<NewCoreData> = NewCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "rssLink == %@", link)
        
        do {            let existingItems = try context.fetch(fetchRequest)
            if existingItems.isEmpty {
                let newItem = NewCoreData(context: context)
                newItem.rssTitle = title
                newItem.rssDescription = description
                newItem.rssPubDate = pubDate
                newItem.rssSource = source
                newItem.rssLink = link
                
                // Download and save image
                
                if let imageData = downloadImage(from: imageUrl) {
                    newItem.rssImage = imageData
                }
                
//                newItem.rssImage = Data()
                
                
                try context.save()
//                print("Item saved successfully!")
                
            } else {
//                print("Item with this link already exists, skipping save.")
            }
        } catch {
            print("Failed to fetch or save item: \(error)")
        }
        
        func downloadImage(from urlString: String) -> Data? {
            guard let url = URL(string: urlString), let data = try? Data(contentsOf: url) else { return nil }
            return data
        }
    }
    
    //MARK: - READ
    
     func fetchAllItems() -> [NewCoreData] {
         let context = persistentContainer.viewContext
         let fetchRequest: NSFetchRequest<NewCoreData> = NewCoreData.fetchRequest()
        do {
            return try context.fetch(fetchRequest) as [NewCoreData]
        } catch {
            print(error.localizedDescription)
        }
        return []
    }
    
    //MARK: - DELETE
    
    func removeAllItems(){
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NewCoreData> = NewCoreData.fetchRequest()
        
        do {
            let rssItems = try? context.fetch(fetchRequest) as [NewCoreData]
            rssItems?.forEach { context.delete($0) }
            print("Удалить")
        }
        
        try? context.save()
        print("Items successfully removed!")
        
    }
    
}
