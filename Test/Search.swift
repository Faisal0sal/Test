//
//  Search.swift
//  Test
//
//  Created by F M S ALSALAMAH on 08/06/2016.
//  Copyright © 2016 F M S ALSALAMAH. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Search: UIViewController {
    
    var tag : String?
    
    override func viewDidLoad() {
        tag = AppState.sharedInstance.tag
        
        navigationItem.title = tag
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
}