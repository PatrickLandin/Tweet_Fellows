//
//  Tweet.swift
//  Tweet_Fellows
//
//  Created by Patrick Landin on 1/5/15.
//  Copyright (c) 2015 Patrick Landin. All rights reserved.


import UIKit

class Tweet {
  var text : String
  var username : String
  var imageURL : String
  var image : UIImage?
  var tweetID : String
  var favoriteCount : String?
  var screenName : String?
  
  init ( _ jsonDictionary : [String : AnyObject]) {
    self.text = jsonDictionary["text"] as String
    let userDictionary = jsonDictionary["user"] as [String: AnyObject]
    self.username = userDictionary["name"] as String
    self.tweetID = jsonDictionary["id_str"] as String
    self.imageURL = userDictionary["profile_image_url"] as String
  }
  
  func updateWithInfo(infoDictionary : [String: AnyObject]) {
    if let favorites = infoDictionary["favorite_count"] as? Int {
    self.favoriteCount = "\(favorites)"
    }
  }
  
  func updateUserTimeline(userDictionary : [String : AnyObject]) {
    let userScreenName = userDictionary["screen_name"] as String
      self.screenName = "\(screenName)"
    }
  }
