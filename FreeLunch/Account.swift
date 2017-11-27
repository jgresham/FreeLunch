//
//  Account.swift
//  FreeLunch
//
//  Created by Johns Gresham on 11/26/17.
//  Copyright © 2017 Johns Gresham. All rights reserved.
//

import UIKit

class Account: NSObject {
    //MARK: Properties
    
    var username: String
    var password: String
    var token: String?
    
    init?(username: String, password: String, token: String?) {
        
        // The name must not be empty
        guard (!username.isEmpty) && (!password.isEmpty)  else {
            return nil
        }
        
        // Initialize stored properties.
        self.username = username
        self.password = password
        self.token = token
        
    }
}
