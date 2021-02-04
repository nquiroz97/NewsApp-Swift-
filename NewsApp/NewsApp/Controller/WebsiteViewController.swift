//
//  WebsiteViewController.swift
//  NewsApp
//
//  Created by Neri Quiroz on 1/10/21.
//

import UIKit
import WebKit

class WebsiteViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    @IBOutlet var webView: WKWebView!
    private var activityIndicatorContainer: UIView!
    private var activityIndicator: UIActivityIndicatorView!
    var urlString: String?
    var dataController: DataController?

    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        webView.navigationDelegate = self
        
        self.webView.uiDelegate = self
        sendRequest(string: urlString!)

        
    }
    
    private func sendRequest(string: String){
        let myURL = URL(string: string)
        let myRequest = URLRequest(url: myURL!)
        
        performUIUpdatesOnMain {
            self.webView.load(myRequest)
            try? self.dataController?.context.save()
        }
    }
    
    fileprivate func setActivityIndicator() {
      // Configure the background containerView for the indicator
      activityIndicatorContainer = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        activityIndicatorContainer.center = webView.center
      // Need to subtract 44 because WebKitView is pinned to SafeArea
      //   and we add the toolbar of height 44 programatically
      activityIndicatorContainer.center = webView.center
      activityIndicatorContainer.backgroundColor = UIColor.black
      activityIndicatorContainer.alpha = 0.8
      activityIndicatorContainer.layer.cornerRadius = 10
    
      // Configure the activity indicator
      activityIndicator = UIActivityIndicatorView()
      activityIndicator.hidesWhenStopped = true
      activityIndicator.style = UIActivityIndicatorView.Style.large
      activityIndicator.translatesAutoresizingMaskIntoConstraints = false
      activityIndicatorContainer.addSubview(activityIndicator)
      webView.addSubview(activityIndicatorContainer)
      
      // Constraints
      activityIndicator.centerXAnchor.constraint(equalTo: activityIndicatorContainer.centerXAnchor).isActive = true
      activityIndicator.centerYAnchor.constraint(equalTo: activityIndicatorContainer.centerYAnchor).isActive = true
    }
    
    fileprivate func showActivityIndicator(show: Bool) {
      if show {
        activityIndicator.startAnimating()
      } else {
        activityIndicator.stopAnimating()
        activityIndicatorContainer.removeFromSuperview()
      }
    }
}

extension WebsiteViewController{
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
      self.showActivityIndicator(show: false)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
      // Set the indicator everytime webView started loading
      self.setActivityIndicator()
      self.showActivityIndicator(show: true)
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
      self.showActivityIndicator(show: false)
        
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error)
        self.showActivityIndicator(show: false)
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default Action"), style: .default, handler: {_ in NSLog("The \"OK\" alert occured")}))
        self.present(alert, animated: true, completion: nil)
    }
}

