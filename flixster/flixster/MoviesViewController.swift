//
//  MoviesViewController.swift
//  flixster
//
//  Created by Qin Ying Chen on 9/23/21.
//

import UIKit
import AlamofireImage

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    // properties (available for the lifetime of this screen...)
    var movies = [[String:Any]]()   // declare array of dictionaries
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        // network request snippet
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
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
                    
                    // TODO: Reload your table view data
                    self.tableView.reloadData()     // needs to call this manually or the screen will not update!
             }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count     // returns the size of the movies array
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // allows for recycling of cell & cast it as MovieCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        let movie = movies[indexPath.row]   // get the movie at the row index
        let title = movie["title"] as! String   // get the title and cast it to String
        let synopsis = movie["overview"] as! String

        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis
        
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
        let cell = sender as! UITableViewCell   // sender is actually the selected cell
        let indexPath = tableView.indexPath(for: cell)!
        let movie = movies[indexPath.row]
        
        // pass the selected movie to the MovieDetailsViewController
        let detailsViewController = segue.destination as! MovieDetailsViewController // cast destination to the destination's ViewController name
        detailsViewController.movie = movie // pass found movie to the view controller by setting the movie property created in the view controller
        
        // deselect the selection (so that when returned, it's not shown as  selected...)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

}
