//
//  ViewController.swift
//  1_RottenTomatoes
//
//  Created by Nathan Shayefar on 2/7/15.
//  Copyright (c) 2015 Nathan Shayefar. All rights reserved.
//

import UIKit
import Foundation

class MoviesViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var movies: [NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 320
        
        // How can I avoid exposing this in plain text?
        let apiKey = "fxd69xpcudd6jcv87bfhyfyd"
        let rottenTomatoesUrl = NSURL(string: "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=" + apiKey)!
        let request = NSURLRequest(URL: rottenTomatoesUrl)
    
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
            (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                let responseDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
                self.movies = responseDictionary["movies"] as [NSDictionary]
                self.tableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MoviesTableViewCellID") as MoviesTableViewCell
        
        // Retrieve all relevant fields that will displayed
        let movie = self.movies[indexPath.row]
        
        let posters = movie["posters"] as NSDictionary
        let posterThumbnail = posters["thumbnail"] as NSString
        
        // Update cell contents
        cell.moviePosterThumbnail.setImageWithURL(NSURL(string: posterThumbnail))
        
        return cell
    }
}

