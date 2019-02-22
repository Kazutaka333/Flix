//
//  ViewController.swift
//  Flix
//
//  Created by Kazutaka Homma on 2/18/19.
//  Copyright © 2019 Kazutaka Homma. All rights reserved.
//

import UIKit
import AlamofireImage

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var movies: [[String: Any]] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        downloadData()
    }
    
    func downloadData() {
        let url = URL(string:  "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                // TODO: Get the array of movies
                let movies: [[String: Any]] = dataDictionary["results"] as! [[String: Any]]
                
                // TODO: Store the movies in a property to use elsewhere
                self.movies = movies
                
                // TODO: Reload your table view data
                self.tableView.reloadData()
            }
        }
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        let movie = movies[indexPath.row]
        
        let vc = segue.destination as! DetailsViewController
        vc.movie = movie
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}



extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let movie = movies[indexPath.row]
        let imgPath = movie["poster_path"] as! String
        let imgUrl = URL(string: baseUrl + imgPath)!
        let title = movie["title"] as! String
        let description = movie["overview"] as! String
        cell.posterImageView.af_setImage(withURL: imgUrl)
        cell.titleLabel.text = title
        cell.descriptionLabel.text = description
        return cell
    }
    
    
}

