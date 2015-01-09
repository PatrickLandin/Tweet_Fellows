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
  var userName : String?
  var userTweets = [Tweet]()

    override func viewDidLoad() {
        super.viewDidLoad()
      
//      self.networkController.fetchUserTimeline(Tweet, completionHandler: { (<#[Tweet]?#>, <#String?#>) -> (Void) in
//        <#code#>
//      })

      self.tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
  
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.userTweets.count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("TWEET_CELL", forIndexPath: indexPath) as TweetCell
    let tweet = self.userTweets[indexPath.row]
    cell.tweetLabel.text = tweet.text
    cell.userNameLabel.text = tweet.username
    if tweet.image == nil {
      self.networkController.fetchImageForTweet(tweet, completionHandler: { (image) -> (Void) in
        //        self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
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
