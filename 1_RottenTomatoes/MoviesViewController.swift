//
//  ViewController.swift
//  1_RottenTomatoes
//
//  Created by Nathan Shayefar on 2/7/15.
//  Copyright (c) 2015 Nathan Shayefar. All rights reserved.
//

import UIKit
import Foundation

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var networkErrorLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var refreshControl: UIRefreshControl!
    var movies: [NSDictionary] = []
    var rottenTomatoesUrlString: String = ""
    
    // How can I avoid exposing this in plain text?
    let apiKey = "fxd69xpcudd6jcv87bfhyfyd"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation bar styling
        self.navigationItem.title = "Top Movies"
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor()]
        navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        navigationController?.navigationBar.tintColor = UIColor.grayColor()
        navigationController?.navigationBar.backgroundColor = UIColor.grayColor()
        
        // The progress indicator is displayed until the network request is completed
        SVProgressHUD.show()
        
        // Enable pull-to-refresh functionality
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        // For some reason, this view is not being centered horizontally. I think it may have to do with my failure to disable autolayout early on, but I haven't been able to fix it yet.
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        // Build and make the request to the RottenTomatoes API
        self.rottenTomatoesUrlString = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=" + apiKey
        
        fetchMovies(rottenTomatoesUrlString)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var viewController = segue.destinationViewController as MovieDetailsViewController
        var indexPath = tableView.indexPathForCell(sender as UITableViewCell)
        
        let movieDict = self.movies[indexPath!.row]
        viewController.movie = Movie(fromDict: movieDict)
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
    
    // Choosing not to use textDidChange to respect API rate limits
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        fetchMovies(self.rottenTomatoesUrlString)
        self.view.endEditing(true)
    }
    
    func fetchMovies(urlString: String) {
        var requestUrlString = urlString
        
        // If text has been entered into the search bar, use it to modify the query string
        let searchBarText = self.searchBar.text
        if (!searchBarText.isEmpty) {
            var escapedSearchBarText = searchBarText.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())! as String
            requestUrlString += "?q=\(escapedSearchBarText)"
        }
        
        println(requestUrlString)
        
        let url = NSURL(string: requestUrlString)!
        let request = NSURLRequest(URL: url)
    
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
            (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
    
            if (error != nil) {
                // Show network error label
                self.networkErrorLabel.hidden = false
            } else {
                // Hide network error label
                self.networkErrorLabel.hidden = true
    
                let responseDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
                
                if (responseDictionary["movies"] == nil) {
                    self.movies = []
                } else {
                    self.movies = responseDictionary["movies"] as [NSDictionary]
                }
                
                self.tableView.reloadData()
            }
    
            self.refreshControl.endRefreshing()
            SVProgressHUD.dismiss()
        }
    }
    
    func onRefresh() {
        fetchMovies(self.rottenTomatoesUrlString)
    }
}

