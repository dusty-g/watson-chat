//
//  someDelegate.swift
//  watson
//
//  Created by Dustin Galindo on 5/18/17.
//  Copyright © 2017 Dustin Galindo. All rights reserved.
//

import UIKit

protocol someDelegate: class {
    func makeMessage(username: String, password: String, version: String)
}
