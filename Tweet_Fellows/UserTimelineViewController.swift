//
//  UserTimelineViewController.swift
//  Tweet_Fellows
//
//  Created by Patrick Landin on 1/8/15.
//  Copyright (c) 2015 Patrick Landin. All rights reserved.
//

import UIKit

class UserTimelineViewController: UIViewController, UITableViewDataSource {
  
  @IBOutlet weak var userBackgroundView: UIImageView!
  @IBOutlet weak var headerNameLabel: UILabel!
  @IBOutlet weak var headerLocationLabel: UILabel!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var headerImageView: UIImageView!
  var networkController : NetworkController!
  var userID : String!
  var userTweet : Tweet!
  var userTweets : [Tweet]?

    override func viewDidLoad() {
        super.viewDidLoad()
//      self.userBackgroundView.image = self.userTweet.image
      self.headerNameLabel.text = self.userTweet.username
      self.headerImageView.image = self.userTweet.image
      self.headerLocationLabel.text = self.userTweet.userLocation
      self.tableView.dataSource = self
      self.tableView.estimatedRowHeight = 100
      self.tableView.rowHeight = UITableViewAutomaticDimension
      self.tableView.registerNib(UINib(nibName: "TweetCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "TWEET_CELL")
      
      self.networkController.fetchUserTimeline(self.userID, completionHandler: { (tweets, errorMessage) -> (Void) in
        self.userTweets = tweets
        self.tableView.reloadData()
      })
      
//      self.networkController.fetchUserBackgroundImage(self.userTweet, completionHandler: { (image) -> () in
//        self.userBackgroundView.image = image
//        self.tableView.reloadData()
//      })
      
      self.networkController.fetchProfileHeader(self.userTweet, completionHandler: { (image) -> () in
        self.userBackgroundView.image = self.userTweet.bannerImage
      })
    }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let tweets = self.userTweets {
      return tweets.count
    } else {
      return 0
    }
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("TWEET_CELL", forIndexPath: indexPath) as TweetCell
    let tweet = self.userTweets![indexPath.row]
    cell.tweetLabel.text = tweet.text
    cell.userNameLabel.text = tweet.username
    if tweet.image == nil {
      self.networkController.fetchImageForTweet(tweet, completionHandler: { (image) -> (Void) in
        //        self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
        //        this was causing scrolling issues in app, shooting user back to top of table.
        cell.tweetImageView.image = tweet.image
      })
    }
    cell.tweetImageView.layer.masksToBounds = true
    cell.tweetImageView.layer.cornerRadius = 6.0
    cell.tweetImageView.layer.borderColor = UIColor.whiteColor().CGColor
    cell.tweetImageView.layer.borderWidth = 0.0
    self.headerImageView.layer.masksToBounds = true
    self.headerImageView.layer.cornerRadius = 6.0;
    self.headerImageView.layer.borderColor = UIColor.whiteColor().CGColor
    self.headerImageView.layer.borderWidth = 2.0;
    
    return cell
  }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}