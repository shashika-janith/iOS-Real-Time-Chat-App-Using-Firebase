//
//  SentImageTableViewCell.swift
//  ChatApp
//
//  Created by Sashika on 3/3/20.
//  Copyright © 2020 Shashika. All rights reserved.
//

import UIKit

class SentImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageSent: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageSent.roundCorners(cornerRadius: 5.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func cellId() -> String {
        return "\(self)"
    }

    func setData(message: Message) {
        imageSent.loadImageFromURL(url: message.imageURL)
    }
}
