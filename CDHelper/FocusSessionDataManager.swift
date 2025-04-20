//
//  Untitled.swift
//  FocusProductivityApp
//
//  Created by Mayur Kant Tyagi on 20/04/25.
//

import Foundation
import CoreData
import SwiftUI

class FocusSessionDataManager: ObservableObject {
    
    static var shared = FocusSessionDataManager()
    
    private let context: NSManagedObjectContext

    private init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }

    // MARK: - Create
    func createSession(focusSession: FocusSession) {
        context.performAndWait{
            let session = FocusSessionCDModel(context: context)
            session.sessionID = focusSession.id.uuidString
            session.mode = focusSession.mode.rawValue
            session.startTime = focusSession.startTime
            session.duration =  String(focusSession.duration)
            session.point = Int16(focusSession.points)
            session.badges = focusSession.badges
            
            saveContext()
        }
    }

    // MARK: - Read
    func fetchSessions() -> [FocusSessionCDModel] {
        context.performAndWait{
            let request: NSFetchRequest<FocusSessionCDModel> = FocusSessionCDModel.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(keyPath: \FocusSessionCDModel.startTime, ascending: false)]
            
            do {
                return try context.fetch(request)
            } catch {
                print("Error fetching sessions: \(error)")
                return []
            }
        }
    }
    
    func getAllSessions() -> [FocusSession]{
        var sessions = [FocusSession]()
        fetchSessions().forEach { cdsession in
            sessions.append(cdsession.parseToFocusSession())
        }
        return sessions
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

extension FocusSessionCDModel{
    
    func parseToFocusSession() -> FocusSession{
        let id = UUID(uuidString: sessionID ?? "") ?? UUID()
        let mode = FocusMode(rawValue: mode ?? "work") ?? .work
        let duration = TimeInterval(Double(duration ?? "0") ?? 0)

        return FocusSession(id: id, mode: mode, startTime: startTime ?? Date(), duration: duration, points: Int(point), badges: badges ?? [])
    }
    
}
