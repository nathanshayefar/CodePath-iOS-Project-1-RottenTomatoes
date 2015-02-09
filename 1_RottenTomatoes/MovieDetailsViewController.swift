//
//  MovieDetailsViewController.swift
//  1_RottenTomatoes
//
//  Created by Nathan Shayefar on 2/8/15.
//  Copyright (c) 2015 Nathan Shayefar. All rights reserved.
//

import Foundation

class MovieDetailsViewController: UIViewController {
    @IBOutlet weak var largePosterView: UIImageView!
    @IBOutlet weak var summaryView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingsLabel: UILabel!
    @IBOutlet weak var mpaaRatingsLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    
    var movie: Movie = Movie()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation bar styling
        self.navigationItem.title = movie.title
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor()]
        navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        navigationController?.navigationBar.tintColor = UIColor.grayColor()
        navigationController?.navigationBar.backgroundColor = UIColor.grayColor()
        
        // Create a placeholder image using the low-fi version of the movie poster
        var placeholderImageView: UIImageView = UIImageView()
        placeholderImageView.setImageWithURL(NSURL(string: movie.posterUrlString))
        
        // Load the higher fidelity version, using the previous poster as a placeholder
        // Note: This might have to go in a completion block of the previous call
        let largePosterUrlString = movie.posterUrlString.stringByReplacingOccurrencesOfString("tmb", withString: "ori")
        largePosterView.setImageWithURL(NSURL(string: largePosterUrlString), placeholderImage: placeholderImageView.image)
        
        titleLabel.text = "\(movie.title) (\(movie.year))"
        ratingsLabel.text = "Critics Score: \(movie.criticRating), Audience Score \(movie.audienceRating)"
        mpaaRatingsLabel.text = movie.mpaaRating
        synopsisLabel.text = movie.synopsis
    }
}
