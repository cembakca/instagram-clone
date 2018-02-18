//
//  SecondViewController.swift
//  InstagramParse
//
//  Created by Cem Bakca on 7.02.2018.
//  Copyright © 2018 Cem Bakca. All rights reserved.
//

import UIKit
import Parse

class uploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postCommentText: UITextView!
    @IBOutlet weak var postButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ekrana dokununca klavye kapansın
        let keyboardRecognizer = UITapGestureRecognizer(target: self, action: #selector(uploadViewController.hideKeyboard))
        self.view.addGestureRecognizer(keyboardRecognizer)
        
        
        postImage.isUserInteractionEnabled = true
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(uploadViewController.chosePhoto))
        postImage.addGestureRecognizer(recognizer)
        
        postButton.isEnabled = false
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }

    @objc func chosePhoto() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        pickerController.allowsEditing = true
        present(pickerController, animated: true, completion: nil)
        postButton.isEnabled = true
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        postImage.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postButtonClicked(_ sender: Any) {
        
        self.postButton.isEnabled = false
        
        let object = PFObject(className: "Posts")
        let data = UIImageJPEGRepresentation(postImage.image!, 0.5)
        let pfImage = PFFile(name: "image.jpg", data: data!)
        
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let dateString = dateFormatter.string(from:date as Date)
        
        object["postimage"] = pfImage
        object["postcomment"] = postCommentText.text
        object["postowner"] = PFUser.current()!.username!
        let uuid = UUID().uuidString
        object["postdate"] = dateString
        object["postuuid"] = "\(uuid)-\(PFUser.current()!.username!)"
        
        object.saveInBackground { (succes, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let okButton = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            } else {
                self.postCommentText.text = ""
                self.postImage.image = UIImage(named: "select.png")
                self.tabBarController?.selectedIndex = 0
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newPost"), object: nil)
            }
        }
    }
    


}

