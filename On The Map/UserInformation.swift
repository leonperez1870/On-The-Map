//
//  UserInformation.swift
//  On The Map
//
//  Created by Leoncio Perez on 5/10/16.
//  Copyright © 2016 Leoncio Perez. All rights reserved.
//

import Foundation

struct UserInformation {
    var firstName = ""
    var lastName = ""
    
    init(dictionary: NSDictionary){
        firstName = dictionary["first_name"] as! String
        lastName = dictionary["last_name"] as! String

    }
}

