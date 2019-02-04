//
//  GalleryTableViewCell.swift
//  Image-Gallery
//
//  Created by Arnab Sen on 04/02/19.
//  Copyright © 2019 Arnab Sen. All rights reserved.
//

import UIKit

class GalleryTableViewCell: UITableViewCell, UITextFieldDelegate {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var textField: UITextField! {
        didSet {
            let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(handleTapEvent(sender:)))
            tapGuesture.numberOfTapsRequired = 2
            addGestureRecognizer(tapGuesture)
        }
    }
    
    @objc private func handleTapEvent(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            textField.isEnabled = true
            textField.becomeFirstResponder()
        }
    }
}
