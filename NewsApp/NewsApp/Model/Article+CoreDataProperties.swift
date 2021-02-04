//
//  Article+CoreDataProperties.swift
//  NewsApp
//
//  Created by Neri Quiroz on 12/29/20.
//

import Foundation
import CoreData

extension Article {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Article> {
        return NSFetchRequest<Article>(entityName: "Article")
    }

    @NSManaged public var articleDate: String?
    @NSManaged public var articleTitle: String?
    @NSManaged public var articleUrl: String?

}
