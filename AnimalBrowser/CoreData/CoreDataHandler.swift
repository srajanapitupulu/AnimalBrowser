//
//  CoreDataHandler.swift
//  AnimalBrowser
//
//  Created by Samuel Napitupulu on 21/01/24.
//

import CoreData

class CoreDataHandler {
    static let shared = CoreDataHandler()
    
    private init() {}
    
    // MARK: - Core Data Stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "AnimalBrowser")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving Support
    
    func saveContext() -> Bool {
        var saveSuccess = false
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                saveSuccess = true
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        
        return saveSuccess
    }
    
    // MARK: - Core Data Retrieve Favorites Photo
    func retrieve(filterByName: String = "") -> [LikedPhotos] {
        let request: NSFetchRequest<LikedPhotos> = LikedPhotos.fetchRequest()
        
        if !filterByName.isEmpty {
            request.predicate = NSPredicate(format: "animal_name = %@", filterByName)
        }
        
        var fetchedPhotos: [LikedPhotos] = []
        
        do {
            fetchedPhotos = try persistentContainer.viewContext.fetch(request)
        } catch let error {
            print("Error fetching songs \(error)")
        }
        return fetchedPhotos
    }
    func isFavorited(pexel_id: Int) -> Bool {
        let request: NSFetchRequest<LikedPhotos> = LikedPhotos.fetchRequest()
        request.predicate = NSPredicate(format: "pexel_id = %d", pexel_id)
        var isFavorited = false
        var fetchedPhotos: [LikedPhotos] = []
        
        do {
            fetchedPhotos = try persistentContainer.viewContext.fetch(request)
            if !fetchedPhotos.isEmpty {
                isFavorited = true
            }
        } catch let error {
            print("Error fetching songs \(error)")
        }
        return isFavorited
    }
    
    // MARK: - Core Data Saving Favorites Photo
    func addFavorite(animal: String, withPhoto: AnimalPhoto) -> Bool {
        let photo = LikedPhotos(context: persistentContainer.viewContext)
        var photos = retrieve()
        
        photo.animal_name = animal
        photo.original_photo = withPhoto.src.original
        photo.thumbnail = withPhoto.src.tiny
        photo.photo = withPhoto.src.large
        photo.photographer = withPhoto.photographer
        photo.photographer_url = withPhoto.photographer_url
        photo.url = withPhoto.url
        photo.pexel_id = Int64(withPhoto.pexel_id)
        photo.width = Int64(withPhoto.width)
        photo.height = Int64(withPhoto.height)
        
        photos.append(photo)
        
        return saveContext()
    }
    
    func deleteFavorite(photo: LikedPhotos) -> Bool {
        let context = persistentContainer.viewContext
        context.delete(photo)
        return saveContext()
    }
}
