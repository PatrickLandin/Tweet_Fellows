//
//  TweetCell.swift
//  Tweet_Fellows
//
//  Created by Patrick Landin on 1/5/15.
//  Copyright (c) 2015 Patrick Landin. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

  @IBOutlet weak var tweetImageView: UIImageView!
  @IBOutlet weak var tweetLabel: UILabel!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var tweetImage: UIImageView!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
