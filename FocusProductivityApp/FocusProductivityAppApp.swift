//
//  FocusProductivityAppApp.swift
//  FocusProductivityApp
//
//  Created by Mayur Kant Tyagi on 20/04/25.
//

import SwiftUI
import CoreData

@main
struct FocusProductivityApp: App {
    @StateObject private var sessionVM = FocusSessionViewModel()
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView(sessionVM: sessionVM)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
}

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "FocusDataModel") // must match your `.xcdatamodeld` file name
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved Core Data error \(error), \(error.userInfo)")
            }
        }
    }
}
