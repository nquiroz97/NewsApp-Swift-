//
//  GuardianAPIClient.swift
//  NewsApp
//
//  Created by Neri Quiroz on 12/27/20.
//

import Foundation
import UIKit

class GuardianAPIClient: NSObject {
    
    var dataController: DataController!
    
    override init() {
        super.init()
    }
    
    class func shared() -> GuardianAPIClient {
        struct Singleton {
            static var shared = GuardianAPIClient()
        }
        return Singleton.shared
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completion(nil, NSError(domain: "taskForGetMethod", code: 1, userInfo: userInfo))
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    sendError("There was an error with your request: \(String(describing: error))")
                }
            }
        }
        task.resume()
        
        return task
    }
    
    
    
    @discardableResult class func allArticles(completion: @escaping ([Article], Error?) -> Void) -> URLSessionDataTask{
        let task = taskForGETRequest(url: Endpoints.general.url, responseType: Response.self) { response, error in
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let sceneDelegate = windowScene.delegate as? SceneDelegate
            else {
                return
            }
            let stack = sceneDelegate.dataController
            if let response = response{
                let articleArray = response.results
                var articleObjects: [Article] = [Article]()
                for article in articleArray{
                    let singleArticle = Article(articleDate: article.webPublicationDate!, articleTitle: article.webTitle!, articleUrl: article.webUrl!, stack.context)
                    articleObjects.append(singleArticle)
                }
                completion(articleObjects, nil)
            }else{
                completion([], error)
            }
        }
        return task
    }

    
}



