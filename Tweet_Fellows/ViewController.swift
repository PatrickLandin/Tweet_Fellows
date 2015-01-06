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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let accountStore = ACAccountStore()
    let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
    accountStore.requestAccessToAccountsWithType(accountType, options: nil) { (granted, error) -> Void in
      if granted {
        let accounts = accountStore.accountsWithAccountType(accountType)
        if !accounts.isEmpty {
          let twitterAccount = accounts.first as ACAccount
          let requestURL = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")
          let twitterRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: requestURL, parameters: nil)
          twitterRequest.account = twitterAccount
          twitterRequest.performRequestWithHandler() { (data, response, error) -> Void in
            switch response.statusCode {
            case 200...299:
              println("Shabooyah")
              
              if let jsonArray = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [AnyObject] {
                for object in jsonArray {
                  if let jsonDictionary = object as? [String : AnyObject] {
                    let tweet = Tweet(jsonDictionary)
                    self.tweets.append(tweet)
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    
                    self.tableView.reloadData()
                    })
                  }
                }
              }
            case 300...599:
              println("Not good...")
            default:
              println("Default thing happended a bit")
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
    cell.userNameLabel.text = tweet.username
    let imgURL = NSURL(string: tweet.imageURL!)
    let imageData = NSData(contentsOfURL: imgURL!)
    let cellImage = UIImage(data: imageData!)
    cell.tweetImage.image = cellImage
    return cell
  }
}

