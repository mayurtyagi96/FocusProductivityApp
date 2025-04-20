//
//  ProfileDataManager.swift
//  FocusProductivityApp
//
//  Created by Mayur Kant Tyagi on 20/04/25.
//

import Foundation
import CoreData
import SwiftUI

class ProfileDataManager: ObservableObject {
    
    static var shared = ProfileDataManager()
    
    private let context: NSManagedObjectContext

    private init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }

    // MARK: - Create
    func createProfile(profile: Profile) {
        context.performAndWait{
            let cdProfile = ProfileCDModel(context: context)
            cdProfile.userName = profile.name
            cdProfile.profilePic = profile.image
            saveContext()
        }
    }

    // MARK: - Read
    func fetchProfile() -> [ProfileCDModel] {
        context.performAndWait{
            let request: NSFetchRequest<ProfileCDModel> = ProfileCDModel.fetchRequest()
            
            do {
                return try context.fetch(request)
            } catch {
                print("Error fetching sessions: \(error)")
                return []
            }
        }
    }
    
    func getProfile() -> Profile?{
        return fetchProfile().first?.parseToProfile()
    }
    
    // MARK: - Save Helper
    private func saveContext() {
            do {
                try context.save()
            } catch {
                print("Error saving Core Data context: \(error)")
            }
        }
}

extension ProfileCDModel{
    
    func parseToProfile() -> Profile{
        Profile(name: userName ?? "", image: profilePic ?? "")
    }
    
}
