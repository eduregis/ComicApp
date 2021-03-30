//
//  Comic+CoreDataClass.swift
//  ComicApp
//
//  Created by Fernando de Lucas da Silva Gomes on 29/03/21.
//  Copyright © 2021 Eduardo Oliveira. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Comic)
public class ComicCD: NSManagedObject {

}


extension ComicCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ComicCD> {
        return NSFetchRequest<ComicCD>(entityName: "Comic")
    }

    @NSManaged public var title: String?
    @NSManaged public var image: Data?
    @NSManaged public var progressNumber: Int64
    @NSManaged public var finishNumber: Int64
    @NSManaged public var type: String?
    @NSManaged public var organizeBy: String?
    @NSManaged public var status: String?
    @NSManaged public var author: String?
    @NSManaged public var artist: String?
    @NSManaged public var lastEdit: Date?
    @NSManaged public var color: String?

}

extension ComicCD : Identifiable {

}
