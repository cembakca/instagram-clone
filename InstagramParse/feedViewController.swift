//
//  FirstViewController.swift
//  InstagramParse
//
//  Created by Cem Bakca on 7.02.2018.
//  Copyright © 2018 Cem Bakca. All rights reserved.
//

import UIKit
import Parse

class feedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var postOwnerArray = [String]()
    var postCommentArray = [String]()
    var postUuidArray = [String]()
    var postDateArray = [String]()
    var postImageArray = [PFFile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(feedViewController.getData), name: NSNotification.Name(rawValue: "newPost"), object: nil)
    }
    
    @objc func getData() {
        let query = PFQuery(className: "Posts")
        query.addDescendingOrder("createAt") // oluşturulma tarihine göre veriyi çekecek.
        
        query.findObjectsInBackground { (objects, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let okButton = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            } else {
                self.postUuidArray.removeAll(keepingCapacity: false)
                self.postCommentArray.removeAll(keepingCapacity: false)
                self.postOwnerArray.removeAll(keepingCapacity: false)
                self.postImageArray.removeAll(keepingCapacity: false)
                
                for object in objects! {
                    self.postOwnerArray.append(object.object(forKey: "postowner") as! String)
                    self.postCommentArray.append(object.object(forKey: "postcomment") as! String)
                    self.postUuidArray.append(object.object(forKey: "postuuid") as! String)
                    self.postDateArray.append(object.object(forKey: "postdate") as! String)
                    self.postImageArray.append(object.object(forKey: "postimage") as! PFFile)


                    
                }
                
            }
            self.tableView.reloadData()
        }
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postOwnerArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! feedCell
        cell.uuidLabel.isHidden = true
        cell.usernameLabel.text = postOwnerArray[indexPath.row]
        cell.dateLabel.text = postDateArray[indexPath.row]
        cell.postComment.text = postCommentArray[indexPath.row]
        cell.uuidLabel.text = postUuidArray[indexPath.row]
        
        postImageArray[indexPath.row].getDataInBackground { (data, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let okButton = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            } else {
                cell.postImage.image = UIImage(data: data!)
            }
        }
        return cell
    }
    

    @IBAction func logoutClicked(_ sender: Any) {
        PFUser.logOutInBackground { (error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let okButton = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            } else {
                UserDefaults.standard.removeObject(forKey: "username")
                UserDefaults.standard.synchronize()
                
                let singIn = self.storyboard?.instantiateViewController(withIdentifier: "singIn") as! SingInViewController
                let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                delegate.window?.rootViewController = singIn
                delegate.rememberUser()
                
                
            }
            
        }
    }
    


}

