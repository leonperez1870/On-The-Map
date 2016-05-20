//
//  UdacityConstants.swift
//  On The Map
//
//  Created by Leoncio Perez on 5/18/16.
//  Copyright © 2016 Leoncio Perez. All rights reserved.
//

extension UdacityClient {
    struct Constants {
        static let parseAppId: String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let parseApiKey: String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        static let UdacityBaseURL: String = "https://www.udacity.com/api/"
        static let ParseBaseURL: String = "https://api.parse.com/1/classes/StudentLocation"
    }
    
    struct RequestToServer {
        static let udacity : String = "udacity"
        static let parse : String = "parse"
    }
    
    struct Methods {
        static let CreateSession : String = "session"
        static let Users : String = "users/"
        static let limit : String = ""
    }
    
    struct  JSONBodyKeys {
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
        
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
    }
    
    struct JSONResponseKeys {
        static let Error = "error"
        static let Status = "status"
        
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MediaUrl = "mediaURL"
    }
}
