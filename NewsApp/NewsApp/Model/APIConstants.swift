//
//  APIConstants.swift
//  NewsApp
//
//  Created by Neri Quiroz on 12/27/20.
//

import Foundation

    struct Result: Codable {
        let apiUrl: String?
        let id: String?
        let isHosted: Bool?
        let pillarId: String?
        let pillarName: String?
        let sectionId: String?
        let sectionName: String?
        let type: String?
        let webPublicationDate: String?
        let webTitle: String?
        let webUrl: String?
        
        enum CodingKeys: String, CodingKey{
            case apiUrl
            case id
            case isHosted
            case pillarId
            case pillarName
            case sectionId
            case sectionName
            case type
            case webPublicationDate
            case webTitle
            case webUrl
        }
            
        init(from decoder: Decoder) throws {
            let container = try? decoder.container(keyedBy: CodingKeys.self)
            self.apiUrl = try container!.decode(String.self, forKey: .apiUrl)
            self.id = try container!.decode(String.self, forKey: .id)
            self.isHosted = try container!.decode(Bool.self, forKey: .isHosted)
            self.pillarId = try container!.decode(String.self, forKey: .pillarId)
            self.pillarName = try container!.decode(String.self, forKey: .pillarName)
            self.sectionId = try container!.decode(String.self, forKey: .sectionId)
            self.sectionName = try container!.decode(String.self, forKey: .sectionName)
            self.type = try container!.decode(String.self, forKey: .type)
            self.webPublicationDate = try container!.decode(String.self, forKey: .webPublicationDate)
            self.webTitle = try container!.decode(String.self, forKey: .webTitle)
            self.webUrl = try container!.decode(String.self, forKey: .webUrl)
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(self.sectionName, forKey: .sectionName)
            try container.encode(self.webPublicationDate, forKey: .webPublicationDate)
            try container.encode(self.webTitle, forKey: .webTitle)
            try container.encode(self.webUrl, forKey: .webUrl)
        }
        
        
    }


struct Response: Codable {
            let currentPage: String?
            let orderBy: String?
            let pageSize: String?
            let pages: String?
            let results: [Result]
            let startIndex: String?
            let status: String?
            let total: String?
            let userTier: String?
        
        enum CodingKeys: String, CodingKey{
            case response = "response"
            case currentPage
            case orderBy
            case pageSize
            case pages
            case results = "results"
            case startIndex
            case status
            case total
            case userTier
        }
        
        init(from decoder: Decoder) throws {
            let container = try? decoder.container(keyedBy: CodingKeys.self)
            let response = try? container?.nestedContainer(keyedBy: CodingKeys.self, forKey: .response)
            self.currentPage = try? response!.decode(String.self, forKey: .currentPage)
            self.orderBy = try? response!.decode(String.self, forKey: .orderBy)
            self.pageSize = try? response!.decode(String.self, forKey: .pageSize)
            self.pages = try? response!.decode(String.self, forKey: .pages)
            self.results = try response!.decode([Result].self, forKey: .results)
            self.startIndex = try? response!.decode(String.self, forKey: .startIndex)
            self.status = try? response!.decode(String.self, forKey: .status)
            self.total = try? response!.decode(String.self, forKey: .total)
            self.userTier = try? response!.decode(String.self, forKey: .userTier)
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            var response = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .response)
            try? response.encode(self.currentPage, forKey: .currentPage)
            try? response.encode(self.orderBy, forKey: .orderBy)
            try? response.encode(self.pageSize, forKey: .pageSize)
            try? response.encode(self.pages, forKey: .pages)
            try? response.encode(self.results, forKey: .results)
            try? response.encode(self.startIndex, forKey: .startIndex)
            try? response.encode(self.status, forKey: .status)
            try? response.encode(self.total, forKey: .total)
            try? response.encode(self.userTier, forKey: .userTier)
        }

}
    

