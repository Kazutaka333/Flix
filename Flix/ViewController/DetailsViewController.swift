//
//  DetailsViewController.swift
//  Flix
//
//  Created by Kazutaka Homma on 2/19/19.
//  Copyright © 2019 Kazutaka Homma. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var backdropView: UIImageView!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    
    var movie : [String: Any]!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setup()
    }
    
    func setup() {
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let baseUrl780 = "https://image.tmdb.org/t/p/w780"
        let backdropPath = movie["backdrop_path"] as! String
        let imgPath = movie["poster_path"] as! String
        let backdropUrl = URL(string: baseUrl780 + backdropPath)!
        let imgUrl = URL(string: baseUrl + imgPath)!
        
        titleLabel.text = movie["title"] as? String
        titleLabel.sizeToFit()
        synopsisLabel.text = movie["overview"] as? String
        synopsisLabel.sizeToFit()
        backdropView.af_setImage(withURL: backdropUrl)
        posterView.af_setImage(withURL: imgUrl)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navController = segue.destination as! UINavigationController
        let vc = navController.topViewController as! TrailerViewController
        vc.movie = movie
    }
    
}
