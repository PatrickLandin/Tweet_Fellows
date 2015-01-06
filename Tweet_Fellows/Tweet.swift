//
//  Tweet.swift
//  Tweet_Fellows
//
//  Created by Patrick Landin on 1/5/15.
//  Copyright (c) 2015 Patrick Landin. All rights reserved.
//

import Foundation
import UIKit

class Tweet {
  var text : String
  var username : String
//  var profilePic : UIImage
  init ( _ jsonDictionary : [String : AnyObject]) {
    self.text = jsonDictionary["text"] as String
    let userDictionary = jsonDictionary["user"] as [String: AnyObject]
    self.username = userDictionary["name"] as String
//    self.profilePic = userDictionary["profile_image_url"] as UIImage
  }
}