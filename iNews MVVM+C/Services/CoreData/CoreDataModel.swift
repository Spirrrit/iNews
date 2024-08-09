//
//  CoreDataModel.swift
//  iNews MVVM+C
//
//  Created by Слава on 23.07.2024.
//
//

import Foundation
import CoreData


@objc(NewCoreData)
public class NewCoreData: NSManagedObject {
    

}

extension NewCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewCoreData> {
        return NSFetchRequest<NewCoreData>(entityName: "NewCoreData")
    }

    @NSManaged public var rssTitle: String?
    @NSManaged public var rssDescription: String?
    @NSManaged public var rssPubDate: Date?
    @NSManaged public var rssImage: Data?
    @NSManaged public var rssSource: String?
    @NSManaged public var rssLink: String?

}

extension NewCoreData : Identifiable {

}
