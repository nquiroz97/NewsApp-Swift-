//
//  APIResponse.swift
//  NewsApp
//
//  Created by Neri Quiroz on 12/28/20.
//

import Foundation

extension GuardianAPIClient{
    
    enum Endpoints {
        static let ApiBase = "https://content.guardianapis.com/search?"
        static let ApiKey = "e33c3283-0d8e-44ae-bbd5-d02234e4b087"
        
        static let ApiString = "https://content.guardianapis.com/search?&api-key=e33c3283-0d8e-44ae-bbd5-d02234e4b087"
        
        case search(String)
        case general
        
        var stringValue: String{
            switch self{
            case .search(let query):
                return Endpoints.ApiBase  + "q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" + "?api_key=\(Endpoints.ApiKey)"
            case .general:
                return Endpoints.ApiString
            }
            
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
}



