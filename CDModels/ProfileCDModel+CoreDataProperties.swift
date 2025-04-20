//
//  ProfileCDModel+CoreDataProperties.swift
//  FocusProductivityApp
//
//  Created by Mayur Kant Tyagi on 20/04/25.
//
//

import Foundation
import CoreData


extension ProfileCDModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProfileCDModel> {
        return NSFetchRequest<ProfileCDModel>(entityName: "ProfileCDModel")
    }

    @NSManaged public var userName: String?
    @NSManaged public var profilePic: String?

}

extension ProfileCDModel : Identifiable {

}
