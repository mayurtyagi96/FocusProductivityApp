//
//  FocusSessionCDModel+CoreDataProperties.swift
//  FocusProductivityApp
//
//  Created by Mayur Kant Tyagi on 20/04/25.
//
//

import Foundation
import CoreData


extension FocusSessionCDModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FocusSessionCDModel> {
        return NSFetchRequest<FocusSessionCDModel>(entityName: "FocusSessionCDModel")
    }

    @NSManaged public var sessionID: String?
    @NSManaged public var mode: String?
    @NSManaged public var startTime: Date?
    @NSManaged public var duration: String?
    @NSManaged public var point: Int16
    @NSManaged public var badges: Array<String>?

}

extension FocusSessionCDModel : Identifiable {

}
