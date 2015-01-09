//
//  TweetDetailController.swift
//  Tweet_Fellows
//
//  Created by Patrick Landin on 1/7/15.
//  Copyright (c) 2015 Patrick Landin. All rights reserved.
//

import UIKit

class TweetDetailController: UIViewController {
  
  var tweet : Tweet!
  var networkController : NetworkController!
  
  @IBOutlet weak var userPictureButton: UIButton!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var tweetLabel: UILabel!
  @IBOutlet weak var tweetFaveLabel: UILabel!
  
    override func viewDidLoad() {
      super.viewDidLoad()
      self.userNameLabel.text = self.tweet.username
      self.tweetLabel.text = self.tweet.text
      self.userPictureButton.setImage(tweet.image, forState: UIControlState.Normal)
      
      self.networkController.fetchTweetInfo(tweet.tweetID, completionHandler: { (infoDictionary, errorMessage) -> () in
        if errorMessage == nil {
        self.tweet.updateWithInfo(infoDictionary!)
        self.tweetFaveLabel.text = self.tweet.favoriteCount
        }
      })
        // Do any additional setup after loading the view.
    }

  @IBAction func userImagePressed(sender: AnyObject) {
    let userTimelineVC = self.storyboard?.instantiateViewControllerWithIdentifier("USER_TIMELINE") as UserTimelineViewController
    userTimelineVC.networkController = self.networkController
    userTimelineVC.userName = tweet.username
    self.navigationController?.pushViewController(userTimelineVC, animated: true)
  }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

