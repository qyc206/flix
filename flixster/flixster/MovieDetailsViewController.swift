//
//  MovieDetailsViewController.swift
//  flixster
//
//  Created by Qin Ying Chen on 9/28/21.
//

import UIKit
import AlamofireImage

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var backdropView: UIImageView!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    // define a movie property
    var movie: [String:Any]! // ! = swift optionals
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // set labels based on info retreived
        titleLabel.text = movie["title"] as? String
        synopsisLabel.text = movie["overview"] as? String
        releaseDateLabel.text = movie["release_date"] as? String
        
        // resize label to fit the text
        titleLabel.sizeToFit()
        synopsisLabel.sizeToFit()
        releaseDateLabel.sizeToFit()
        
        // get poster & backdrop URL from api
        let posterRes = "/w185"
        let backdropRes = "/w780"
        
        let baseURL = "https://image.tmdb.org/t/p"
        let posterPath = movie["poster_path"] as! String
        let posterURL = URL(string: baseURL+posterRes+posterPath)
        let backdropPath = movie["backdrop_path"] as! String
        let backdroprURL = URL(string: baseURL+backdropRes+backdropPath)
        
        // use AlamofireImage to grab poster from URL and display it
        posterView.af.setImage(withURL: posterURL!)
        backdropView.af.setImage(withURL: backdroprURL!)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
