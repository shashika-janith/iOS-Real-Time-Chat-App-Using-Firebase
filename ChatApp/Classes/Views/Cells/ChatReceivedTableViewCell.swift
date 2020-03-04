//
//  ChatReceivedTableViewCell.swift
//  ChatApp
//
//  Created by Sashika on 2/28/20.
//  Copyright © 2020 Shashika. All rights reserved.
//

import UIKit

class ChatReceivedTableViewCell: UITableViewCell {

    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var senderName: UILabel!
    @IBOutlet weak var messageContainer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        messageContainer.roundCorners(cornerRadius: 5.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func cellId() -> String {
        return "\(self)"
    }
    
    func setData(message: Message) {
        lblMessage.text = message.content
        senderName.text = message.senderName
    }

}
