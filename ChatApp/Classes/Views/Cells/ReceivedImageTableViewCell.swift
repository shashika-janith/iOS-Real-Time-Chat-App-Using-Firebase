//
//  ReceivedImageTableViewCell.swift
//  ChatApp
//
//  Created by Sashika on 3/3/20.
//  Copyright © 2020 Shashika. All rights reserved.
//

import UIKit

class ReceivedImageTableViewCell: UITableViewCell {

    @IBOutlet weak var imageReceived: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageReceived.roundCorners(cornerRadius: 5.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func cellId() -> String {
        return "\(self)"
    }
    
    func setData(message: Message) {
        imageReceived.loadImageFromURL(url: message.imageURL)
    }

}
