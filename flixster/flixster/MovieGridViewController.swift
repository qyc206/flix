//
//  MovieGridViewController.swift
//  flixster
//
//  Created by Qin Ying Chen on 9/29/21.
//

import UIKit
import AlamofireImage

class MovieGridViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // properties (available for the lifetime of this screen...)
    var movies = [[String:Any]]()   // declare array of dictionaries

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        
        // declare & configure layout
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.minimumLineSpacing = 4 // controls space in between rows (in pixels)
        layout.minimumInteritemSpacing = 4 // controls space between columns (in pixels)
        
        let width = (view.frame.size.width-layout.minimumInteritemSpacing*2) / 2 // get width of the phone
        layout.itemSize = CGSize(width: width, height: width*3/2)
        
        
        // network request snippet
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/297762/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")! // black widow
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]

                // get the array of movies & store movies to use elsewhere
                self.movies = dataDictionary["results"] as! [[String:Any]]   // as! = casting as the type that follows
                // reload data
                self.collectionView.reloadData()     // needs to call this manually or the screen will not update!
            }
        }
        task.resume()
        
        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as! MovieGridCell
        
        // get the movie
        let movie = movies[indexPath.item]
        
        // get poster URL from api
        let baseURL = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterURL = URL(string: baseURL+posterPath)
        
        // use AlamofireImage to grab poster from URL and display it
        cell.posterView.af.setImage(withURL: posterURL!)
        
        return cell
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        // find the selected movie
        let cell = sender as! UICollectionViewCell   // sender is actually the selected cell
        let indexPath = collectionView.indexPath(for: cell)!
        let movie = movies[indexPath.row]
        
        // pass the selected movie to the MovieDetailsViewController
        let detailsViewController = segue.destination as! MovieGridDetailsViewController // cast destination to the destination's ViewController name
        detailsViewController.movie = movie // pass found movie to the view controller by setting the movie property created in the view controller
    }
    

}
