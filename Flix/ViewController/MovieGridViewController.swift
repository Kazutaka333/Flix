//
//  MovieGridViewController.swift
//  Flix
//
//  Created by Kazutaka Homma on 2/19/19.
//  Copyright © 2019 Kazutaka Homma. All rights reserved.
//

import UIKit

class MovieGridViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var movies : [[String : Any]] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadData()
        setItemSize(viewSize: view.frame.size)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        setItemSize(viewSize: size)
    }
    
    func setItemSize(viewSize: CGSize) {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        let width = (viewSize.width - layout.minimumLineSpacing*2)/3
        layout.itemSize = CGSize(width: width, height: width*1.5)
    }
    
    func downloadData() {
        let url = URL(string:  "https://api.themoviedb.org/3/movie/297762/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
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
                self.collectionView.reloadData()
            }
        }
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UICollectionViewCell
        let indexPath = collectionView.indexPath(for: cell)!
        let movie = movies[indexPath.row]
        
        let vc = segue.destination as! DetailsViewController
        vc.movie = movie
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension MovieGridViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as! MovieGridCell
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let movie = movies[indexPath.item]
        let imgPath = movie["poster_path"] as! String
        let imgUrl = URL(string: baseUrl + imgPath)!
        cell.posterView.af_setImage(withURL: imgUrl)
        return cell
    }
}
