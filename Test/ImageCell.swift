//
//  ImageCell.swift
//  Test
//
//  Created by F M S ALSALAMAH on 18/06/2016.
//  Copyright © 2016 F M S ALSALAMAH. All rights reserved.
//

import UIKit

class ImageCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func prepareForReuse() {
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}