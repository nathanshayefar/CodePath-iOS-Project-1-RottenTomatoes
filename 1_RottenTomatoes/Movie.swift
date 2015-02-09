//
//  Movie.swift
//  1_RottenTomatoes
//
//  Created by Nathan Shayefar on 2/8/15.
//  Copyright (c) 2015 Nathan Shayefar. All rights reserved.
//

import Foundation

struct Movie {
    let posterUrlString: NSString
    let title: NSString
    let year: Int
    let runtime: Int
    let mpaaRating: String
    let criticRating: Int
    let audienceRating: Int
    let synopsis: String
    
    init(fromDict movie: NSDictionary) {
        let posters = movie["posters"] as NSDictionary
        posterUrlString = posters["thumbnail"] as NSString
        title = movie["title"] as NSString
        year = movie["year"] as Int
        runtime = movie["runtime"] as Int
        mpaaRating = movie["mpaa_rating"] as NSString
        let ratings = movie["ratings"] as NSDictionary
        criticRating = ratings["critics_score"] as Int
        audienceRating = ratings["audience_score"] as Int
        synopsis = movie["synopsis"] as NSString
    }
    
    // Have meaningless empty values here is not ideal, but I wanted easy access to a dummy value
    init() {
        posterUrlString = ""
        title = ""
        year = 0
        runtime = 0
        mpaaRating = ""
        criticRating = 0
        audienceRating = 0
        synopsis = ""
    }
}
