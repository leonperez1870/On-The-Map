//
//  FacebookClient.swift
//  On The Map
//
//  Created by Leoncio Perez on 5/25/16.
//  Copyright © 2016 Leoncio Perez. All rights reserved.
//

//import Foundation
//
//class FacebookClient {
//    
//    private let loginManager = FBSDKLoginManager()
//    private static var sharedInstance = FacebookClient()
//    
//    class func sharedClient() -> FacebookClient {
//        return sharedInstance
//    }
//    
//    class func activeApp() {
//        FBSDKAppEvents.activateApp()
//    }
//    
//    class func setupWithOptions(application: UIApplication, launchOptions: [NSObject: AnyObject]?) -> Bool {
//        FBSDKSettings.setAppURLSchemeSuffix(FacebookClient.Common.URLSuffix)
//        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
//    }
//    
//    class func processURL(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
//        if url.scheme == FacebookClient.Common.URLScheme {
//            return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
//        } else {
//            return true
//        }
//    }
//    
//    func currentAccessToken() -> FBSDKAccessToken! {
//        return FBSDKAccessToken.currentAccessToken()
//    }
//    
//    func logout() {
//        loginManager.logOut()
//    }
//}