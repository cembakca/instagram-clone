//
//  SingUpViewController.swift
//  InstagramParse
//
//  Created by Cem Bakca on 12.02.2018.
//  Copyright © 2018 Cem Bakca. All rights reserved.
//

import UIKit
import Parse

class SingUpViewController: UIViewController {

    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var ageText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func singInClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func singUpClicked(_ sender: Any) {
        if usernameText.text != "" && emailText.text != "" && passwordText.text != "" {
            let user = PFUser()
            user.username = usernameText.text!
            user.email = emailText.text!
            user.password = passwordText.text!
            user["age"] = ageText.text
            user.signUpInBackground(block: { (succes, error) in
                if error != nil {
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    let okButton = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    print("user created")
                    UserDefaults.standard.set(self.usernameText.text!, forKey: "username")
                    UserDefaults.standard.synchronize()
                    
                    let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    delegate.rememberUser()
                }
            })
            
        }else {
            let alert = UIAlertController(title: "Error", message: "Username and password needed", preferredStyle: UIAlertControllerStyle.alert)
            let okButton = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    

}
