//
//  UIImage.swift
//  ChatApp
//
//  Created by Sashika on 3/3/20.
//  Copyright © 2020 Shashika. All rights reserved.
//

import UIKit
import SDWebImage

extension UIImageView {

    func loadImageFromURL(url: String?) {
        if let url = URL(string: url ?? "") {
            self.sd_setImage(with: url, completed: nil)
            self.contentMode = .scaleAspectFill
        }
    }
    
}
