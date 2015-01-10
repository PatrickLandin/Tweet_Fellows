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
  var backgroundImage : UIImage?
  var tweetID : String
  var favoriteCount : String?
  var userID : String
  var userBackground : String
  var userLocation : String
  var bannerImage : UIImage?
  var screenName : String
  
  init ( _ jsonDictionary : [String : AnyObject]) {
    self.text = jsonDictionary["text"] as String
    let userDictionary = jsonDictionary["user"] as [String: AnyObject]
    self.username = userDictionary["name"] as String
    self.tweetID = jsonDictionary["id_str"] as String
    self.imageURL = userDictionary["profile_image_url"] as String
    self.userID = userDictionary["id_str"] as String
    self.userBackground = userDictionary["profile_background_image_url_https"] as String
    self.userLocation = userDictionary["location"] as String
    self.screenName = userDictionary["screen_name"] as String
  }
  
  func updateWithInfo(infoDictionary : [String: AnyObject]) {
    if let favorites = infoDictionary["favorite_count"] as? Int {
    self.favoriteCount = "\(favorites)"
    }
  }
}