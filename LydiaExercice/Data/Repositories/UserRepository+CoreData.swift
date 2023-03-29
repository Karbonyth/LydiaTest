//
//  UserRepository+CoreData.swift
//  LydiaExercice
//
//  Created by Karbonyth on 28/03/2023.
//

import Foundation
import CoreData

extension UserRepository {
    
    private func getContext() -> NSManagedObjectContext? {
        let container = NSPersistentContainer(name: "LydiaExercice")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container.viewContext
    }

    func saveUsersToPersistence(newUsers: [User], context: NSManagedObjectContext?) {
        guard let context = context else { return }
        
        context.perform {
            do {
                for user in newUsers {
                    let userEntity = UserEntity(context: context)
                    userEntity.name = UserNameEntity(context: context)
                    userEntity.name?.first = user.name.first
                    userEntity.name?.last = user.name.last
                    userEntity.name?.title = user.name.title
                    userEntity.gender = user.gender.rawValue
                    userEntity.picture = UserPictureEntity(context: context)
                    userEntity.picture?.url = user.picture.url
                    if let image = user.picture.image {
                        userEntity.picture?.image = image.pngData()
                    }
                    userEntity.birthInfo = BirthInfoEntity(context: context)
                    userEntity.birthInfo?.date = user.birthInfo.date
                    userEntity.birthInfo?.age = Int32(user.birthInfo.age)
                    userEntity.contactInfo = UserContactEntity(context: context)
                    userEntity.contactInfo?.homePhone = user.contactInfo.homePhone
                    userEntity.contactInfo?.mobilePhone = user.contactInfo.mobilePhone
                }
                try context.save()
                print("Users saved to persistence: \(newUsers.count)")
            } catch {
                print("Error saving users to Core Data: \(error.localizedDescription)")
            }
        }
    }
    
    func loadUsersFromPersistence(context: NSManagedObjectContext?) -> [User] {
        guard let context = context else { return [] }
        
        return context.performAndWait {
            let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
            do {
                let fetchedUsers = try context.fetch(request)
                print("Users loaded from persistence: \(fetchedUsers.count)")
                return fetchedUsers.map { User(from: $0) }
            } catch {
                print("Error loading users from Core Data: \(error.localizedDescription)")
                return []
            }
        }
    }
    
    func purgeUsersFromPersistence(context: NSManagedObjectContext?, completion: @escaping () -> Void) {
        guard let context = context else { return }
        
        context.perform {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = UserEntity.fetchRequest()
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try context.execute(deleteRequest)
                try context.save()
                print("Users purged from persistence")
                completion()
            } catch {
                print("Error deleting users from Core Data: \(error.localizedDescription)")
                completion()
            }
        }
    }
}
