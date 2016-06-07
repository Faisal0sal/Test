//
//  Chats.swift
//  Test
//
//  Created by F M S ALSALAMAH on 24/05/2016.
//  Copyright © 2016 F M S ALSALAMAH. All rights reserved.
//

import Foundation
import UIKit

class Tags: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tagField: UITextField!
    
    let trendingTags : [String] = ["Game of thrones","Peaky blinders"]
    
    override func viewDidLoad() {
        
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated: true)
        // -- Add bottom borders to buttons
        tagField.addBorder(.Bottom, color: UIColor(red: CGFloat(207/255.0), green: CGFloat(207/255.0), blue: CGFloat(207/255.0), alpha: CGFloat(1.0)), width: 2.0)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trendingTags.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = trendingTags[indexPath.row]
        
        return cell
    }
}