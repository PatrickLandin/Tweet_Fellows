
import Foundation
import Accounts
import Social

class NetworkController {
  
  var twitterAccount : ACAccount?
  var imageQueue = NSOperationQueue()
  
  init() {
    //empty init fancy time because because of the optional property
  }
  
  func fetchHomeTimeline( completionHandler : ([Tweet]?, String?) -> (Void)) {
    
    let accountStore = ACAccountStore()
    let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
    accountStore.requestAccessToAccountsWithType(accountType, options: nil) { (granted, error) -> Void in
      if granted {
        let accounts = accountStore.accountsWithAccountType(accountType)
        if !accounts.isEmpty {
          self.twitterAccount = accounts.first as? ACAccount
          // finished with getting twitter account access
          let requestURL = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")
          let twitterRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: requestURL, parameters: nil)
          twitterRequest.account = self.twitterAccount
          twitterRequest.performRequestWithHandler() { (data, response, error) -> Void in
            switch response.statusCode {
            case 200...299:
              println("fetch home timeline worked!")
              
              if let jsonArray = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [AnyObject] {
                var tweets = [Tweet]()
                for object in jsonArray {
                  if let jsonDictionary = object as? [String : AnyObject] {
                    let tweet = Tweet(jsonDictionary)
                    tweets.append(tweet)
                  }
                }
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                      completionHandler(tweets, nil)
                    })
              }
              
            case 300...599:
              println("Not good...")
              completionHandler(nil, "A bad thing happened")
            default:
              println("Default thing happended a bit")
            }
          }
        }
      }
    }
  }
  
  func fetchTweetInfo(tweetID : String, completionHandler : ([String :AnyObject]?, String?) -> (Void)) {
    
          let requestURL = NSURL(string: "https://api.twitter.com/1.1/statuses/show.json?id=\(tweetID)")
          let twitterRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: requestURL!, parameters: nil)
          twitterRequest.account = self.twitterAccount
    
          twitterRequest.performRequestWithHandler() { (data, response, error) -> Void in
            switch response.statusCode {
            case 200...299:
              println("fetch tweet info worked!")
              
            if let jsonDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [String : AnyObject] {
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                  completionHandler(jsonDictionary, nil)
                  })
                }
            default:
              println("default thing happened a bit")
              }
            }
          }

  func fetchImageForTweet(tweet : Tweet, completionHandler: (UIImage?) -> ()) {
    // Image download
    if let imageURL = NSURL(string: tweet.imageURL) {
      self.imageQueue.addOperationWithBlock({ () -> Void in
        if let imageData = NSData(contentsOfURL: imageURL) {
          tweet.image = UIImage(data: imageData)
          NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
            completionHandler(tweet.image)
          })
        }
      })
    }
  }
  
  func fetchUserTimeline(userID : String, completionHandler : ([Tweet]?, String?) -> ()) {
    let requestURL = NSURL(string: "https://api.twitter.com/1.1/statuses/user_timeline.json?user_id=\(userID)")
    let twitterRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: requestURL, parameters: nil)
    twitterRequest.account = self.twitterAccount
    twitterRequest.performRequestWithHandler() { (data, response, error) -> Void in
      switch response.statusCode {
      case 200...299:
        println("fetch user timeline worked!")
        
        if let jsonArray = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [AnyObject] {
          var tweets = [Tweet]()
          for object in jsonArray {
            if let jsonDictionary = object as? [String : AnyObject] {
              let tweet = Tweet(jsonDictionary)
              tweets.append(tweet)
            }
          }
          NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
            completionHandler(tweets, nil)
          })
        }
        
      case 300...599:
        println("Not good...")
        completionHandler(nil, "A bad thing happened")
      default:
        println("Default thing happended a bit")
      }
    }
  }
  
  func fetchProfileBanner (tweet : Tweet, completionHandler: (image: UIImage?) -> ()) {
    let requestURL = NSURL(string: "https://api.twitter.com/1.1/users/profile_banner.json?screen_name=\(tweet.screenName)")
    let twitterRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: requestURL, parameters: nil)
    twitterRequest.account = self.twitterAccount
    twitterRequest.performRequestWithHandler() { (data, response, error) -> Void in
      switch response.statusCode {
      case 200...299:
        println("fetch tweet banner worked brilliantly")
        
          if let jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [String : AnyObject] {
            
            if let sizes = jsonResult["sizes"] as? [String : AnyObject] {
              if let webRetina = sizes["web_retina"] as? [String : AnyObject] {
                var bannerURL = webRetina["url"] as String
                
                if let imageData = NSData(contentsOfURL: NSURL(string: bannerURL)!) {
                  tweet.bannerImage = UIImage(data: imageData)
                }
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                  completionHandler(image: tweet.bannerImage)
              })
            }
          }
        }
          default:
            println("default thing happened a bit for banner method")
          }
        }
      }
  
} // fin