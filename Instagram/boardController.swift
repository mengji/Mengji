//
//  boardController.swift
//  Instagram
//
//  Created by Xiangrui on 3/1/15.
//  Copyright (c) 2015 Xiangrui. All rights reserved.
//

import UIKit

class boardController: UITableViewController {

    var titles = [String]()
    var usernames = [String]()
    var images = [UIImage]()
    var pffile = [PFFile]()
    var objectId = [String]()
    var comments = Array<Array<String>>()
    var refresher:UIRefreshControl!
    
    @IBAction func logout(sender: AnyObject) {
        PFUser.logOut()
        self.performSegueWithIdentifier("logout", sender: self)
        self.navigationController?.navigationBarHidden = true
        self.tabBarController?.tabBar.hidden = true
        
    }
    
    func update(){
        titles = [String]()
        pffile = [PFFile]()
        usernames = [String]()
        var getFollowingQuery = PFQuery(className: "followers")
        getFollowingQuery.whereKey("follower", equalTo: PFUser.currentUser().username)
        getFollowingQuery.findObjectsInBackgroundWithBlock({
            (objects:[AnyObject]!,error:NSError!) in
            if (error == nil){
                var followedUser = ""
                for object in objects{
                    followedUser = object["following"] as String
                    var query = PFQuery(className: "postImage")
                    query.whereKey("name", equalTo: followedUser)
                    query.findObjectsInBackgroundWithBlock({
                        (objects:[AnyObject]!, error:NSError!) in
                        if (error == nil){
                            for object in objects{
                                self.titles.append(object["Title"] as String)
                                self.usernames.append(object["name"] as String)
                                self.pffile.append(object["imageFile"] as PFFile)
                                self.objectId.append(object.objectId as String)
                                self.comments.append(object["comments"] as Array<String>)
                                self.tableView.reloadData()
                            }
                        } else {
                            
                        }
                    })
                }
            }
            self.refresher.endRefreshing()
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        update()
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: "update", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refresher)

        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usernames.count
    }
    

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var myCell: cell =  self.tableView.dequeueReusableCellWithIdentifier("myCell") as cell
        if (usernames.count > 0){
            myCell.fillCell(objectId[indexPath.row], username: usernames[indexPath.row], title: titles[indexPath.row], file: pffile[indexPath.row],comment: comments[indexPath.row])
            /*myCell.myText?.text = usernames[indexPath.row] + ": " + titles[indexPath.row]
            pffile[indexPath.row].getDataInBackgroundWithBlock({
                (imageData:NSData!,error:NSError!) in
                if (error == nil){
                    let image = UIImage(data:imageData)
                    myCell.postedImage.image = image
            
                    
                }
            })*/
        }

        return myCell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 350
    }
    
    
    
        
    
}
