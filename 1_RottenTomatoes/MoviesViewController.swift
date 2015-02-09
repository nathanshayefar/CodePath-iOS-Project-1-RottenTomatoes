//
//  ViewController.swift
//  1_RottenTomatoes
//
//  Created by Nathan Shayefar on 2/7/15.
//  Copyright (c) 2015 Nathan Shayefar. All rights reserved.
//

import UIKit
import Foundation

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var networkErrorLabel: UILabel!
    
    var movies: [NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.show()
        
        // How can I avoid exposing this in plain text?
        let apiKey = "fxd69xpcudd6jcv87bfhyfyd"
        let rottenTomatoesUrl = NSURL(string: "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=" + apiKey)!
        let request = NSURLRequest(URL: rottenTomatoesUrl)
    
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
            (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            if (error != nil) {
                // Show network error label
                self.networkErrorLabel.hidden = false
            } else {
                // Hide network error label
                self.networkErrorLabel.hidden = true
                
                let responseDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
                self.movies = responseDictionary["movies"] as [NSDictionary]
                self.tableView.reloadData()
            }
            
            SVProgressHUD.dismiss()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var vc = segue.destinationViewController as MovieDetailsViewController
        var indexPath = tableView.indexPathForCell(sender as UITableViewCell)
        
        let movieDict = self.movies[indexPath!.row]
        vc.movie = Movie(fromDict: movieDict)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MoviesTableViewCellID") as MoviesTableViewCell
        
        // Retrieve all relevant fields that will displayed
        let movieDict = self.movies[indexPath.row]
        let movie = Movie(fromDict: movieDict)
        
        // Update cell contents
        cell.moviePosterThumbnail.setImageWithURL(NSURL(string: movie.posterUrlString))
        
        cell.titleLabel.text = movie.title
        cell.synopsisLabel.text = movie.synopsis
        cell.mpaaRatingLabel.text = "(" + movie.mpaaRating + ")"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

