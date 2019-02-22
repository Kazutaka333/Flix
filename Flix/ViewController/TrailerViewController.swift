//
//  TrailerViewController.swift
//  Flix
//
//  Created by Kazutaka Homma on 2/22/19.
//  Copyright © 2019 Kazutaka Homma. All rights reserved.
//

import UIKit
import WebKit

class TrailerViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    var movie : [String : Any]!
    
    override func viewDidLoad() {
        loadWebView()
    }
    
    func loadWebView() {
        let movieId = movie["id"] as! NSNumber
        let path = "https://api.themoviedb.org/3/movie/\(movieId)/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string:path)!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                // TODO: Get the array of movies
                let videos: [[String: Any]] = dataDictionary["results"] as! [[String: Any]]
                let key = videos[0]["key"] as! String
                let videoPath = "https://www.youtube.com/watch?v=\(key)"
                let videoUrl = URL(string: videoPath)!
                let videoRequest = URLRequest(url: videoUrl)
                self.webView.load(videoRequest)
            }
        }
        task.resume()
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
}
