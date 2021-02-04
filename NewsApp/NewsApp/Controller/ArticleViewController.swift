//
//  ArticleViewController.swift
//  NewsApp
//
//  Created by Neri Quiroz on 1/1/21.
//

import Foundation
import CoreData
import UIKit

class ArticleViewController: UIViewController, NSFetchedResultsControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // Articles
    var articles: [Article] = [Article]()
    // Data Stack
    var dataController: DataController?
    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Article.fetchRequest()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate
        else {
            return
        }
        _ = sceneDelegate.dataController
        
        hideActivityIndicator()
        tableView.delegate = self
        tableView.backgroundView = activityIndicator
        articles = fetchArticles()
        
    
        if (articles.count) <= 0 {
            showActivityIndicator()
            loadArticles()
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView?.reloadData()
    }
    
    func fetchArticles() -> [Article] {
        var articles = [Article]()
        
        
        do {
            let results = try dataController?.context.fetch(fetchRequest) as! [Article]
            articles = results
        } catch let e as NSError {
            print("Error while trying to perform a search: \n\(e)")
        }
        
        return articles

    }
    
    
    func loadArticles() {
        
         GuardianAPIClient.allArticles { (array, error) in
            
            if error != nil{
                let alert = UIAlertController(title: "Error", message: "Check your internet connection", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default Action"), style: .default, handler: {_ in NSLog("The \"OK\" alert occured")}))
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
            }else{
                self.articles = array
                print(self.articles)
                performUIUpdatesOnMain {
                    self.tableView.reloadData()
                    self.hideActivityIndicator()
 
                }
            }
        }
    }
    
    @IBAction func onRefresh(_ sender: UIBarButtonItem){
        for article in articles {
            dataController?.context.delete(article)
        }
        showActivityIndicator()
        articles = [Article]()
        tableView.reloadData()
        loadArticles()
    }
    
    func showActivityIndicator() {
        activityIndicator?.center = self.view.center
        activityIndicator?.startAnimating()
    }

    func hideActivityIndicator(){
        activityIndicator?.stopAnimating()
        
    }
    
}


extension ArticleViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleViewCell") as! TableViewCell
        
        let article = articles[indexPath.row]
        
        let RFC3339DateFormatter = DateFormatter()
        RFC3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
        RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        RFC3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
         
        /* 39 minutes and 57 seconds after the 16th hour of December 19th, 1996 with an offset of -08:00 from UTC (Pacific Standard Time) */
        let date = RFC3339DateFormatter.date(from: article.articleDate!)
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        
        performUIUpdatesOnMain {
            cell.articleNameLabel.text = article.articleTitle
            cell.articleDateLabel.text = formatter.string(from: date!)
            try? self.dataController?.context.save()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowWebsiteSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ShowWebsiteSegue") {
            let indexPaths = self.tableView!.indexPathsForSelectedRows!
            let indexPath = indexPaths[0] as NSIndexPath
            let wesbiteVC = segue.destination as! WebsiteViewController
            let article = articles[indexPath.row]
            wesbiteVC.urlString = article.articleUrl
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let animation = AnimationFactory.makeSlideIn(duration: 0.5, delayFactor: 0.05)
        let animator = Animator(animation: animation)
        animator.animate(cell: cell, at: indexPath, in: tableView)
    }
}


