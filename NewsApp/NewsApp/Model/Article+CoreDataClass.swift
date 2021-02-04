//
//  Article+CoreDataClass.swift
//  NewsApp
//
//  Created by Neri Quiroz on 12/29/20.
//

import Foundation
import CoreData

@objc(Article)
public class Article: NSManagedObject {
    convenience init(articleDate: String, articleTitle: String, articleUrl: String, _ context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: "Article", in: context) {
            self.init(entity: ent, insertInto: context)
            self.articleDate = articleDate
            self.articleTitle = articleTitle
            self.articleUrl = articleUrl
        } else {
            fatalError("Unable to find Entity name!")
        }
    }
}
