//
//  feedCell.swift
//  InstagramParse
//
//  Created by Cem Bakca on 15.02.2018.
//  Copyright © 2018 Cem Bakca. All rights reserved.
//

import UIKit
import Parse

class feedCell: UITableViewCell {
    @IBOutlet weak var postImage: UIImageView!

    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var uuidLabel: UILabel!
    @IBOutlet weak var postComment: UITextView!
    var userclicked = 0
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //uuidLabel gözükmesin post idsi görünecek çünkü
        uuidLabel.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func likeClicked(_ sender: Any) {
        
        
        if userclicked == 0 {
            let likeObject = PFObject(className: "Likes")
            likeObject["from"] = PFUser.current()?.username!
            likeObject["to"] = uuidLabel.text
            
            likeObject.saveInBackground { (success, error) in
                if error != nil {
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    let okButton = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
                    alert.addAction(okButton)
                    UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                } else {
                    print("like success.")
                }
            }
            userclicked = 1
        } else {
            likeButton.isEnabled = true

        }
        
        
        
    }
    
    @IBAction func commentClicked(_ sender: Any) {
        print("MARK: Comment Cell, ViewController...")
    }
    
    

}
