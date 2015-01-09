//
//  UserTimelineViewController.swift
//  Tweet_Fellows
//
//  Created by Patrick Landin on 1/8/15.
//  Copyright (c) 2015 Patrick Landin. All rights reserved.
//

import UIKit

class UserTimelineViewController: UIViewController, UITableViewDataSource {
  
  @IBOutlet weak var tableView: UITableView!
  var networkController : NetworkController!
  var userID : String!
  var userTweets : [Tweet]?

    override func viewDidLoad() {
        super.viewDidLoad()
      self.tableView.dataSource = self
      self.tableView.estimatedRowHeight = 100
      self.tableView.rowHeight = UITableViewAutomaticDimension
      self.tableView.registerNib(UINib(nibName: "TweetCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "TWEET_CELL")
      self.networkController.fetchUserTimeline(self.userID, completionHandler: { (tweets, errorMessage) -> (Void) in
        self.userTweets = tweets
        self.tableView.reloadData()
      })
        // Do any additional setup after loading the view.
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
    cell.userNameLabel.text = tweet.userID
    if tweet.image == nil {
      self.networkController.fetchImageForTweet(tweet, completionHandler: { (image) -> (Void) in
        //        self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
        //        this was causing scrolling issues in app, shooting user back to top of table.
        cell.tweetImageView.image = tweet.image
      })
    }
    return cell
  }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}