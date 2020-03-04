//
//  ClannelTableViewCell.swift
//  ChatApp
//
//  Created by Sashika on 2/28/20.
//  Copyright © 2020 Shashika. All rights reserved.
//

import Foundation
import UIKit

class ChannelTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblChannelName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static func cellId() -> String {
        return "\(self)"
    }
    
    func setData(channel: Channel) {
        lblChannelName.text = channel.name
    }
}
