//
//  credentials.swift
//  Clerkie App
//
//  Created by Ram Sri Charan on 8/30/18.
//  Copyright © 2018 Ram Sri Charan. All rights reserved.
//

import Foundation

class Credentials {
    var credentials = ["John" : "1122334455",
                       "Sam": "12345678",
                       "9876543210" : "12341234"]

    public func getCredentials() -> [String:String]
    {
        return credentials
    }
}
