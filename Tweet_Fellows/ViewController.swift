//
//  ViewController.swift
//  Tweet_Fellows
//
//  Created by Patrick Landin on 1/5/15.
//  Copyright (c) 2015 Patrick Landin. All rights reserved.


import UIKit
import Accounts
import Social

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  @IBOutlet weak var tableView: UITableView!
  var tweets = [Tweet]()
  let networkController = NetworkController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
//    self.navigationController?.navigationBar.barTintColor = UIColor.blueColor()
    
    self.tableView.dataSource = self
    self.tableView.delegate = self
    self.tableView.registerNib(UINib(nibName: "TweetCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "TWEET_CELL")
    self.tableView.estimatedRowHeight = 100

    self.tableView.rowHeight = UITableViewAutomaticDimension
    
    self.networkController.fetchHomeTimeline { (tweets, errorString) -> () in
      if errorString == nil {
        self.tweets = tweets!
        self.tableView.reloadData()
      } else {
        //Bad Stuff! Should probably give user an error message.
      }
    }
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.tweets.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("TWEET_CELL", forIndexPath: indexPath) as TweetCell
    let tweet = self.tweets[indexPath.row]
    cell.tweetLabel.text = tweet.text
    cell.userNameLabel.text = tweet.username
    if tweet.image == nil {
      self.networkController.fetchImageForTweet(tweet, completionHandler: { (image) -> (Void) in
        cell.tweetImageView.image = tweet.image
      })
    } else {
      cell.tweetImageView?.image = tweet.image?
    }
    cell.tweetImageView.layer.masksToBounds = true
    cell.tweetImageView.layer.cornerRadius = 6.0
    cell.tweetImageView.layer.borderColor = UIColor.whiteColor().CGColor
    cell.tweetImageView.layer.borderWidth = 0.0
    
    return cell
  }
  
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let tweetVC = self.storyboard?.instantiateViewControllerWithIdentifier("TWEET_VC") as TweetDetailController
    tweetVC.networkController = self.networkController
    tweetVC.tweet = self.tweets[indexPath.row]
    self.navigationController?.pushViewController(tweetVC, animated: true)
  }
}


