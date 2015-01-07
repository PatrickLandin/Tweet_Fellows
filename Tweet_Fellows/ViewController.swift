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
          
    self.tableView.dataSource = self
    self.tableView.delegate = self
    
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
    let imgURL = NSURL(string: tweet.imageURL!)
    let imageData = NSData(contentsOfURL: imgURL!)
    let cellImage = UIImage(data: imageData!)
    cell.tweetImage.image = cellImage
    return cell
  }
}

