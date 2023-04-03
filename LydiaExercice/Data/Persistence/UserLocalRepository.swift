//
//  UserRepository.swift
//  LydiaExercice
//
//  Created by Stephen Sement on 28/03/2023.
//

import Foundation
import CoreData

protocol UserLocalRepositoryProtocol {
    func saveUsersToPersistence(newUsers: [User])
    func loadUsersFromPersistence() -> [User]
    func purgeUsersFromPersistence()
    func saveSeedToPersistence(seed: String)
    func loadSeedFromPersistence() -> String?
    func purgeSeedFromPersistence()
}

class UserLocalRepository: UserLocalRepositoryProtocol {
    
    func saveUsersToPersistence(newUsers: [User]) {
        guard let context = LocalRepositoryManagement.shared.getContext(.background) else { return }
        
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
    
    func loadUsersFromPersistence() -> [User] {
        guard let context = LocalRepositoryManagement.shared.getContext(.main) else { return [] }
        
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
    
    func purgeUsersFromPersistence() {
        guard let context = LocalRepositoryManagement.shared.getContext(.background) else {
            return
        }
        
        context.perform {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = UserEntity.fetchRequest()
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try context.execute(deleteRequest)
                try context.save()
                print("Users purged from persistence")
            } catch {
                print("Error deleting users from Core Data: \(error.localizedDescription)")
            }
        }
    }
    
    func saveSeedToPersistence(seed: String) {
        guard let context = LocalRepositoryManagement.shared.getContext(.background) else { return }
        
        context.perform {
            do {
                let seedEntity = SeedEntity(context: context)
                seedEntity.seed = seed
                try context.save()
            } catch {
                print("Error saving seed to Core Data: \(error.localizedDescription)")
            }
        }
    }
    
    func loadSeedFromPersistence() -> String? {
        guard let context = LocalRepositoryManagement.shared.getContext(.main) else { return nil }
        
        return context.performAndWait {
            let request: NSFetchRequest<SeedEntity> = SeedEntity.fetchRequest()
            do {
                let fetchedSeed = try context.fetch(request).first
                print("Seed loaded from persistence")
                return fetchedSeed?.seed
            } catch {
                return nil
            }
        }
    }
    
    func purgeSeedFromPersistence() {
        guard let context = LocalRepositoryManagement.shared.getContext(.background) else {
            return
        }
        
        context.perform {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = SeedEntity.fetchRequest()
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try context.execute(deleteRequest)
                try context.save()
                print("Seed purged from persistence")
            } catch {
                print("Error deleting seed from Core Data: \(error.localizedDescription)")
            }
        }
    }
    
    
}
