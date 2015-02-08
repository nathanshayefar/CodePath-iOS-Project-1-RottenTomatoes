//
//  MoviesTableViewCell.swift
//  1_RottenTomatoes
//
//  Created by Nathan Shayefar on 2/7/15.
//  Copyright (c) 2015 Nathan Shayefar. All rights reserved.
//

import UIKit

class MoviesTableViewCell: UITableViewCell {
    @IBOutlet weak var moviePosterThumbnail: UIImageView!
    @IBOutlet weak var mpaaRatingLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
