//
//  ViewController.swift
//  Tweet_Fellows
//
//  Created by Patrick Landin on 1/5/15.
//  Copyright (c) 2015 Patrick Landin. All rights reserved.


import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  @IBOutlet weak var tableView: UITableView!
  
  var tweets = [Tweet]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let jsonPath = NSBundle.mainBundle().pathForResource("tweet", ofType: "json") {
      
      if let jsonData = NSData(contentsOfFile: jsonPath) {
        var error : NSError?
        if let jsonArray = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: &error) as? [AnyObject] {
          for object in jsonArray {
            if let jsonDictionary = object as? [String : AnyObject] {
              let tweet = Tweet(jsonDictionary)
              self.tweets.append(tweet)
            }
          }
        }
      }
    }
        
    self.tableView.dataSource = self
    self.tableView.delegate = self
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.tweets.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("TWEET_CELL", forIndexPath: indexPath) as TweetCell
    let tweet = self.tweets[indexPath.row]
    cell.tweetLabel.text = tweet.text
    return cell
  }
}

