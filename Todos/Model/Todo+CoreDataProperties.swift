//
//  Todo+CoreDataProperties.swift
//  Todos
//
//  Created by Abdelrhman Ahmed on 25/04/2022.
//
//

import Foundation
import CoreData


extension Todo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Todo> {
        return NSFetchRequest<Todo>(entityName: "Todo")
    }

    @NSManaged public var name: String?
    @NSManaged public var details: String?
    @NSManaged public var priority: String?

}

extension Todo : Identifiable {

}
